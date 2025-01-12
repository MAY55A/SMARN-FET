import 'package:flutter/foundation.dart';
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
import 'package:smarn/services/schedule_service.dart';
import 'package:smarn/services/time_service.dart';

enum ConstraintCheck {
  passesAllConstraints,
  passesRequiredConstraints,
  failsRequiredConstraints,
}

class TimetableGenerationService {
  final ConstraintService _constraintService = ConstraintService();
  final ValueNotifier<List<String>> logs = ValueNotifier([]);
  final Map<String, int> _entitiesFailingRates = {};

  List<Activity> _allActivities = [];
  List<Room> _allRooms = [];
  final Map<String, List<TimeConstraint>> _timeConstraints = {};
  final Map<String, List<SpaceConstraint>> _constraintsPerRoom = {};
  final Map<WorkDay, Map<String, List<String>>> _hoursPerDay = {};
  final Map<WorkDay, Map<String, List<String>>> _breaksPerDay = {};
  final Map<WorkDay, Map<String, List<String>>> _availableHoursPerDay = {};
  Map<String, int> _nbStudentsPerClass = {};
  final Map<ActivityTag, RoomType> _activitiesRequiredRoomType = {};
  int _minActivityDuration = 0;
  int _maxActivityDuration = 0;

  final List<Activity> _scheduledActivities = [];

  Future<void> generateTimetables() async {
    try {
      await _fetchData();
      _addLog("All data fetched successfully!");

      bool res = _scheduleActivities(_allActivities);
      if (res) {
        _addLog("\n GENERATION SUCCESS");
        _addLog(
            "*******Scheduled Activities : *********\n$_scheduledActivities");
        _assignSchedules();
      } else {
        _addLog("\n GENERATION FAILED");
        _addLog("\n Most failing entities: \n");
        _addLog(getMostFailingEntities()
            .entries
            .map((e) => "${e.key}: ${e.value}")
            .join('\n'));
      }
    } catch (error) {
      _addLog("An error occurred: $error");
    }
  }

  Future<void> _fetchData() {
    return Future.wait([
      _fetchActivities(),
      _fetchRooms(),
      _fetchTimeConstraints(),
      _fetchSpaceConstraints(),
      _fetchSchedulingRules(),
      _fetchNbStudentsPerClass(),
    ]);
  }

  Future<void> _fetchActivities() async {
    _allActivities = await ActivityService().getActiveActivities();
  }

  Future<void> _fetchRooms() async {
    _allRooms = await RoomService().getAllRooms();
  }

  Future<void> _fetchTimeConstraints() async {
    var timeConstraints = await _constraintService
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

    _addLog("***** fetched time constraints: *****\n$_timeConstraints");
  }

  Future<void> _fetchSpaceConstraints() async {
    var spaceConstraints = await _constraintService
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

    _addLog("***** fetched room constraints: *****\n$_constraintsPerRoom");
    _addLog(
        "***** fetched roomType constraints: *****\n$_activitiesRequiredRoomType");
  }

  Future<void> _fetchSchedulingRules() async {
    var schedulingRules = await _constraintService
        .getActiveConstraintsByCategory(ConstraintCategory.schedulingRule);
    _minActivityDuration =
        (await _constraintService.getMinMaxDuration('min')) ?? 30;
    _maxActivityDuration =
        (await _constraintService.getMinMaxDuration('max')) ?? 240;
    _addLog(
        "***** fetched min activity duration : *****\n$_minActivityDuration");
    _addLog(
        "***** fetched max activity duration : *****\n$_maxActivityDuration");

    for (var rule in schedulingRules) {
      rule = rule as SchedulingRule;
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
      _availableHoursPerDay[day] = {
        "startTimes": _hoursPerDay[day]!["startTimes"]!
            .where((hour) =>
                !(_breaksPerDay[day]?["startTimes"] ?? []).contains(hour))
            .toList(),
        "endTimes": _hoursPerDay[day]!["endTimes"]!
            .where((hour) =>
                !(_breaksPerDay[day]?["endTimes"] ?? []).contains(hour))
            .toList()
      };
    }

    _addLog(
        "***** fetched scheduling rules: *****\n$_hoursPerDay\n$_breaksPerDay\n$_availableHoursPerDay");
    _addLog(
        "***** fetched durations: *****\n$_minActivityDuration\n$_maxActivityDuration");
  }

  Future<void> _fetchNbStudentsPerClass() async {
    _nbStudentsPerClass = await ClassService().getAllClassesNbStudents();

    _addLog("***** fetched NbStudentsPerClass: *****\n$_nbStudentsPerClass");
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
        if (_scheduleActivities(activities)) {
          return true;
        } else {
          _scheduledActivities.removeLast();
        }
      }
      return false;
    }
  }

  List<Activity> _getPossibleSchedulesForActivity(Activity activity) {
    List<Activity> possibleSchedules = [];

    for (var day in WorkDay.values) {
      if (_availableHoursPerDay[day] != null) {
        for (var hour in _availableHoursPerDay[day]!["startTimes"]!) {
          Activity scheduledActivity = activity.getScheduledActivity(day, hour);
          if (!_availableHoursPerDay[day]!["endTimes"]!
              .contains(scheduledActivity.endTime)) {
            continue;
          }
          ;
          if (_checkTimeConstraints(scheduledActivity)) {
            for (Room room in _allRooms) {
              var res = _checkSpaceConstraints(scheduledActivity, room);
              if (res != ConstraintCheck.failsRequiredConstraints) {
                scheduledActivity.room = room.id;
                if (res == ConstraintCheck.passesAllConstraints) {
                  possibleSchedules.insert(0, scheduledActivity);
                } else {
                  possibleSchedules.add(scheduledActivity);
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
    return res;
  }

  ConstraintCheck _checkSpaceConstraints(Activity activity, Room room) {
    // Check space constraints for the room

    if (_checkRoomAvailability(activity, room) &&
        _checkRoomCapacity(activity, room) &&
        _checkRequiredRoomType(activity, room)) {
      if (_checkPreferredRoom(activity, room)) {
        return ConstraintCheck.passesAllConstraints;
      } else {
        return ConstraintCheck.passesRequiredConstraints;
      }
    }
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
        return true;
      }
    }
    _incrementFailingRate(activity.teacher);
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
        return true;
      }
    }
    _incrementFailingRate(activity.studentsClass);
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
        return true;
      }
    }
    _incrementFailingRate(room.id!);
    return false;
  }

  bool _checkRequiredRoomType(Activity activity, Room room) {
    var requiredRoomType = _activitiesRequiredRoomType[activity.tag];
    var res = requiredRoomType == null || requiredRoomType == room.type;
    if (!res) _incrementFailingRate(requiredRoomType.name);
    return res;
  }

  bool _checkRoomCapacity(Activity activity, Room room) {
    var res = room.capacity >= _nbStudentsPerClass[activity.studentsClass]!;
    if (!res) _incrementFailingRate(room.id!);
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
    _addLog("*** Schedules assigned successfully ***\n$schedules");
    var res =
        await ScheduleService().createSchedules(schedules.values.toList());
    _addLog(res["message"]);
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

  void _addLog(String message) {
    logs.value = [...logs.value, message];
  }

  void _incrementFailingRate(String entityId) {
    if (!_entitiesFailingRates.containsKey(entityId)) {
      _entitiesFailingRates[entityId] = 0;
    }
    _entitiesFailingRates[entityId] = 1 + _entitiesFailingRates[entityId]!;
  }

  Map<String, int> getMostFailingEntities() {
    var top10Map = Map.fromEntries(
      _entitiesFailingRates.entries.toList()
        ..sort((e1, e2) => e2.value.compareTo(e1.value))
        ..take(10),
    );
    return top10Map;
  }
}
