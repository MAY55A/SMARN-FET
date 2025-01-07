import 'package:flutter/rendering.dart';
import 'package:smarn/models/activity_tag.dart';
import 'package:smarn/models/work_day.dart';
import 'package:smarn/services/time_service.dart';

class Activity {
  String? id;
  String subject;
  String teacher;
  String studentsClass;
  bool isActive;
  // duration in minutes
  int duration;
  WorkDay? day;
  String? startTime;
  String? endTime;
  ActivityTag tag;
  String? room;

  // Constructor
  Activity({
    this.id,
    required this.subject,
    required this.teacher,
    required this.studentsClass,
    required this.duration,
    required this.tag,
    this.day,
    this.startTime,
    this.endTime,
    this.room,
    this.isActive = true,
  });

  // Convert a Activity object into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'teacher': teacher,
      'studentsClass': studentsClass,
      'tag': tag.name,
      'duration': duration,
      'room': room,
      'day': day?.name,
      'startTime': startTime,
      'endTime': endTime,
      'isActive': isActive,
    };
  }

  // Create a Activity object from a Map
  factory Activity.fromMap(Map<String, dynamic> map) {
    if (map['id'] == null ||
        map['subject'] == null ||
        map['teacher'] == null ||
        map['studentsClass'] == null ||
        map['duration'] == null ||
        map['tag'] == null) {
      throw ArgumentError('Missing required field');
    }
    return Activity(
        id: map['id'],
        subject: map['subject'],
        teacher: map['teacher'],
        studentsClass: map['studentsClass'],
        tag: ActivityTag.values.firstWhere((e) => e.name == map['tag']),
        day: map['day'] != null
            ? WorkDay.values.firstWhere((d) => d.name == map['day'])
            : null,
        startTime: map['startTime'],
        endTime: map['endTime'],
        isActive: map['isActive'],
        duration: map['duration'],
        room: map['room']);
  }

  bool equals(Activity a) {
    return id == a.id &&
        subject == a.subject &&
        teacher == a.teacher &&
        studentsClass == a.studentsClass &&
        tag == a.tag &&
        isActive == a.isActive &&
        duration == a.duration &&
        room == a.room &&
        startTime == a.startTime &&
        endTime == a.endTime;
  }

  Activity getScheduledActivity(WorkDay day, String startTime) {
    var startMinutes = TimeService.timeToMinutes(startTime);
    var endMinutes = startMinutes + duration;
    var endTime = TimeService.minutesToTime(endMinutes);
    return Activity(
        id: id,
        subject: subject,
        teacher: teacher,
        studentsClass: studentsClass,
        tag: tag,
        isActive: isActive,
        duration: duration,
        day: day,
        startTime: startTime,
        endTime: endTime,
        room: room);
  }

// Function to check if two activities overlap
  bool overlaps(Activity other) {
    final start1 = TimeService.timeToMinutes(startTime!);
    final end1 = TimeService.timeToMinutes(endTime!);
    final start2 = TimeService.timeToMinutes(other.startTime!);
    final end2 = TimeService.timeToMinutes(other.endTime!);

    return start1 < end2 && start2 < end1;
  }

// Function to check if an activity is within a given boundary
  bool isWithinBoundary(String start, String end) {
    final activityStartMinutes = TimeService.timeToMinutes(startTime!);
    final activityEndMinutes = TimeService.timeToMinutes(endTime!);
    final boundaryStartMinutes = TimeService.timeToMinutes(start);
    final boundaryEndMinutes = TimeService.timeToMinutes(end);

    return activityStartMinutes >= boundaryStartMinutes &&
        activityEndMinutes <= boundaryEndMinutes;
  }

  @override
  String toString() {
    return 'Activity{\nid: $id,\n subject: $subject,\n teacher: $teacher,\n class: $studentsClass,\n tag: $tag,\n isActive: $isActive,\n duration(minutes): $duration,\n room: $room,\n startTime: $startTime,\n endTime: $endTime\n}';
  }
}
