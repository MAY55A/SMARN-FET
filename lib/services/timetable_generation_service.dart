import 'package:smarn/models/activity.dart';
import 'package:smarn/models/activity_tag.dart';
import 'package:smarn/models/constraint.dart';
import 'package:smarn/models/room.dart';
import 'package:smarn/models/room_type.dart';
import 'package:smarn/models/schedule.dart';
import 'package:smarn/models/work_day.dart';
import 'package:smarn/services/activity_service.dart';
import 'package:smarn/services/class_service.dart';
import 'package:smarn/services/room_service.dart';
import 'package:smarn/services/constraint_service.dart';
import 'package:smarn/services/time_service.dart';

enum ConstraintCheck {
  passesAllConstraints,
  passesRequiredConstraints,
  failsRequiredConstraints,
}

class TimetableGenerationService {
  late List<Activity> _allActivities;
  late List<Room> _allRooms;
  late Map<String, List<TimeConstraint>> _timeConstraints;
  late Map<String, List<SpaceConstraint>> _constraintsPerRoom;
  late Map<WorkDay, List<String>> _hoursPerDay;
  late Map<WorkDay, List<String>> _breaksPerDay;
  late Map<WorkDay, List<String>> _availableHoursPerDay;
  late Map<String, int> _nbStudentsPerClass;
  late Map<ActivityTag, RoomType> _activitiesRequiredRoomType;
  late int _minActivityDuration;
  late int _maxActivityDuration;

  final List<Activity> _scheduledActivities = [];

  TimetableGenerationService() {
    _fetchSchedulingRules();
  }

  Map<WorkDay, List<String>> get hoursPerDay => _hoursPerDay;
  Map<WorkDay, List<String>> get breaksPerDay => _breaksPerDay;
  Map<WorkDay, List<String>> get availableHoursPerDay => _availableHoursPerDay;
  int get minActivityDuration => _minActivityDuration;
  int get maxActivityDuration => _maxActivityDuration;

  void generateTimetables() {
    _fetchData();
    var res = _scheduleActivities(_allActivities);

    if (res) {
      print("\n GENERATION SUCCESS");
      //_assignSchedules();
    } else {
      print("\n GENERATION FAILED");
    }
    print("\n*******scheduled Activities : *********\n$_scheduledActivities");
  }

  void _fetchData() {
    _fetchActivities();
    _fetchRooms();
    _fetchTimeConstraints();
    _fetchSpaceConstraints();
    _fetchNbStudentsPerClass();
  }

  void _fetchActivities() async {
    _allActivities = await ActivityService().getActiveActivities();
  }

  void _fetchRooms() async {
    _allRooms = await RoomService().getAllRooms();
  }

  void _fetchTimeConstraints() async {
    var timeConstraints = await ConstraintService()
        .getActiveConstraintsByCategory(ConstraintCategory.timeConstraint);
    for (var constraint in timeConstraints) {
      constraint = (constraint as TimeConstraint);
      var id =
          (constraint.classId ?? constraint.teacherId ?? constraint.roomId)!;
      if (!_timeConstraints.containsKey(id)) {
        _timeConstraints[id] = [constraint];
      } else {
        _timeConstraints[id]!.add(constraint);
      }
    }

    print("***** fetched time constraints: *****\n$_timeConstraints\n");
  }

  void _fetchSpaceConstraints() async {
    var spaceConstraints = await ConstraintService()
        .getActiveConstraintsByCategory(ConstraintCategory.spaceConstraint);
    for (var constraint in spaceConstraints) {
      constraint = (constraint as SpaceConstraint);
      if (constraint.type == SpaceConstraintType.roomType) {
        _activitiesRequiredRoomType[constraint.activityType!] =
            constraint.requiredRoomType!;
      } else {
        if (!_constraintsPerRoom.containsKey(constraint.roomId)) {
          _constraintsPerRoom[constraint.roomId!] = [constraint];
        } else {
          _constraintsPerRoom[constraint.roomId]!.add(constraint);
        }
      }
    }

    print("***** fetched room constraints: *****\n$_constraintsPerRoom\n");
    print(
        "***** fetched roomType constraints: *****\n$_activitiesRequiredRoomType\n");
  }

  void _fetchSchedulingRules() async {
    var schedulingRules = await ConstraintService()
            .getActiveConstraintsByCategory(ConstraintCategory.schedulingRule)
        as List<SchedulingRule>;
    _minActivityDuration =
        (await ConstraintService().getMinMaxDuration('min'))!;
    _maxActivityDuration =
        (await ConstraintService().getMinMaxDuration('max'))!;

    for (var rule in schedulingRules) {
      if (rule.type == SchedulingRuleType.breakPeriod) {
        for (var day in rule.applicableDays!) {
          _breaksPerDay[day] = TimeService.generateHours(
              rule.startTime!, rule.endTime!, _minActivityDuration);
        }
      } else if (rule.type == SchedulingRuleType.workPeriod) {
        for (var day in rule.applicableDays!) {
          _hoursPerDay[day] = TimeService.generateHours(
              rule.startTime!, rule.endTime!, _minActivityDuration);
        }
      }
    }

    for (var day in _hoursPerDay.keys) {
      _availableHoursPerDay[day] = _hoursPerDay[day]!
          .where((hour) => !(_breaksPerDay[day] ?? []).contains(hour))
          .toList();
    }

    print(
        "***** fetched scheduling rules: *****\n$_hoursPerDay\n$_breaksPerDay\n$_availableHoursPerDay\n");
  }

  void _fetchNbStudentsPerClass() async {
    _nbStudentsPerClass = await ClassService().getAllClassesNbStudents();

    print("***** fetched NbStudentsPerClass: *****\n$_nbStudentsPerClass\n");
  }

  bool _scheduleActivities(List<Activity> activities) {
    if (activities.isEmpty) return true;
    Activity currentActivity = activities.removeAt(0);
    List<Activity> possibleScheduledActivities =
        _getPossibleSchedulesForActivity(currentActivity);
    if (possibleScheduledActivities.isEmpty) {
      return false;
    } else {
      for (Activity activity in possibleScheduledActivities) {
        _scheduledActivities.add(activity);
        print("\n ADDING scheduled activity : $activity");
        if (_scheduleActivities(activities)) {
          return true;
        } else {
          _scheduledActivities.removeLast();
          print("\n REMOVING scheduled activity : $activity");
        }
      }
      return false;
    }
  }

  List<Activity> _getPossibleSchedulesForActivity(Activity activity) {
    List<Activity> possibleSchedules = [];

    for (var day in WorkDay.values) {
      if (_availableHoursPerDay[day] != null) {
        for (var hour in _availableHoursPerDay[day]!) {
          print("\n Scheduling activity : ${activity.id} on $day at $hour");
          Activity scheduledActivity = activity.getScheduledActivity(day, hour);
          if (_checkTimeConstraints(scheduledActivity)) {
            for (Room room in _allRooms) {
              var res = _checkSpaceConstraints(scheduledActivity, room);
              if (res != ConstraintCheck.failsRequiredConstraints) {
                scheduledActivity.room = room.id;
                if (res == ConstraintCheck.passesAllConstraints) {
                  possibleSchedules.add(scheduledActivity);
                } else {
                  possibleSchedules.insert(
                      possibleSchedules.length, scheduledActivity);
                }
              }
            }
          }
        }
      }
    }
    return possibleSchedules;
  }

  bool _checkTimeConstraints(Activity scheduledActivity) {
    // Check time constraints for the scheduled activity
    var res = _checkTeacherAvailability(scheduledActivity) &&
        _checkClassAvailability(scheduledActivity);
    print("\n PASSED ALL TEACHER AND CLASS TIME CONSTRAINTS ? : $res");
    return res;
  }

  ConstraintCheck _checkSpaceConstraints(Activity activity, Room room) {
    // Check space constraints for the room

    if (_checkRoomAvailability(activity, room) &&
        _checkRoomCapacity(activity, room) &&
        _checkRequiredRoomType(activity, room)) {
      if (_checkPreferredRoom(activity, room)) {
        print("\n room ${room.id} passed all constraints");
        return ConstraintCheck.passesAllConstraints;
      } else {
        print("\n room ${room.id} passed required constraints");
        return ConstraintCheck.passesRequiredConstraints;
      }
    }
    print("\n room ${room.id} failed required constraints");
    return ConstraintCheck.failsRequiredConstraints;
  }

  bool _checkTeacherAvailability(Activity activity) {
    // Check teacher availability for the activity
    // check teacher time constraint at the activity day
    var teacherTimeConstraint =
        _getTimeConstraintByDay(activity.teacher, activity.day!);
    if (teacherTimeConstraint == null ||
        activity.isWithinBoundary(
            teacherTimeConstraint.startTime!, teacherTimeConstraint.endTime!)) {
      // check if teacher teaches another activity
      if (!_scheduledActivities
          .any((a) => a.teacher == activity.teacher && a.overlaps(activity))) {
        print("\n teacher ${activity.teacher} passed availability check");

        return true;
      }
    }
    print("\n teacher ${activity.teacher} didn't pass availability check");

    return false;
  }

  bool _checkClassAvailability(Activity activity) {
    // Check class availability for the activity
    // check class time constraint at the activity day
    var classTimeConstraint =
        _getTimeConstraintByDay(activity.studentsClass, activity.day!);
    if (classTimeConstraint == null ||
        activity.isWithinBoundary(
            classTimeConstraint.startTime!, classTimeConstraint.endTime!)) {
      // check if class is having another activity
      if (!_scheduledActivities.any((a) =>
          a.studentsClass == activity.studentsClass && a.overlaps(activity))) {
        print("\n class ${activity.studentsClass} passed availability check");
        return true;
      }
    }
    print("\n class ${activity.studentsClass} didn't pass availability check");
    return false;
  }

  bool _checkRoomAvailability(Activity activity, Room room) {
    var roomTimeConstraint = _getTimeConstraintByDay(room.id!, activity.day!);
    if (roomTimeConstraint == null ||
        activity.isWithinBoundary(
            roomTimeConstraint.startTime!, roomTimeConstraint.endTime!)) {
      // check if room is occupied by another activity
      if (!_scheduledActivities
          .any((a) => a.room == room.id && a.overlaps(activity))) {
        print("\n room ${room.id} passed availability check");
        return true;
      }
    }
    print("\n room ${room.id} didn't pass availability check");
    return false;
  }

  bool _checkRequiredRoomType(Activity activity, Room room) {
    var requiredRoomType = _activitiesRequiredRoomType[activity.tag];
    var res = requiredRoomType == null || requiredRoomType == room.type;
    print("\n room ${room.id} passed required room type check ? $res");
    return res;
  }

  bool _checkRoomCapacity(Activity activity, Room room) {
    var res = room.capacity >= _nbStudentsPerClass[activity.studentsClass]!;
    print("\n room ${room.id} passed required capacity check ? $res");
    return res;
  }

  bool _checkPreferredRoom(Activity activity, Room room) {
    // Check preferred room for the activity teacher, class and subject
    var preferredRoomConstraints = _constraintsPerRoom[room.id];
    var res = preferredRoomConstraints == null ||
        preferredRoomConstraints.any((c) =>
            c.teacherId == activity.teacher ||
            c.classId == activity.studentsClass ||
            c.subjectId == activity.subject);
    print("\n room ${room.id} passed preferred room check ? $res");
    return res;
  }

  TimeConstraint? _getTimeConstraintByDay(String id, WorkDay day) {
    return _timeConstraints[id]
        ?.where((c) => c.availableDays.contains(day))
        .firstOrNull;
  }

  Future<void> _assignSchedules() async {
    final Map<String, Schedule> schedules = {};

    for (var activity in _scheduledActivities) {
      var detailedActivity = await _getDetailedActivity(activity);

      for (var id in [
        activity.teacher,
        activity.studentsClass,
        activity.room!
      ]) {
        if (!schedules.containsKey(id)) {
          schedules[id] = Schedule(
            belongsTo: id,
            activities: [],
            creationDate: DateTime.now().toIso8601String(),
          );
        }
        schedules[id]!.activities.add(detailedActivity);
      }
    }
    print("*** Schedules assigned successfully ***\n$schedules");
    //ScheduleService().createSchedules(schedules.values.toList());
    print("*** Schedules created successfully ***");
  }

  Future<Activity> _getDetailedActivity(Activity activity) async {
    var activityDetailed =
        await ActivityService().getActivityDetails(activity.id!);
    return Activity(
      id: activity.id,
      tag: activity.tag,
      subject: activityDetailed!["subject"]["name"],
      teacher: activityDetailed["teacher"]["name"],
      studentsClass: activityDetailed["studentsClass"]["name"],
      duration: activity.duration,
      day: activity.day,
      startTime: activity.startTime,
      endTime: activity.endTime,
      room: _allRooms.firstWhere((r) => r.id == activity.room).name,
    );
  }
}
