import 'package:smarn/models/activity_tag.dart';
import 'package:smarn/models/work_day.dart';

class Activity {
  String? id;
  String subject;
  String teacher;
  String studentsClass;
  bool isActive;
  // duration in minutes
  int duration;
  String? day;  // i changed from WorkDay to String cuz it make a prolem
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
     this.isActive =true ,
  });

  // Convert a Activity object into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'teacher': teacher,
      'class': studentsClass,
      'tag': tag.name,
      'duration': duration,
      'room': room,
      'day': day,
      'startTime': startTime,
      'endTime': endTime,
      'isActive': isActive,
    };
  }

  // Create a Activity object from a Map
  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
        id: map['id'],
        subject: map['subject'] ?? '', // Default to empty string if null
        teacher: map['teacher'] ?? '', // Default to empty string if null
        studentsClass: map['class'] ?? '', // Default to empty string if null
        tag: map['tag'] != null
            ? ActivityTag.values.firstWhere(
                (e) => e.name == map['tag'],
                orElse: () =>
                    ActivityTag.lecture, // Default to 'lecture' if invalid tag
              )
            : ActivityTag.lecture, // Default to 'lecture' if null
        day: map['day'],
        startTime: map['startTime'],
        endTime: map['endTime'],
        isActive: map['isActive'] ?? true, // Default to true if null
        duration: map['duration'] ?? 0, // Default to 0 if null
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

  @override
  String toString() {
    return 'Activity{\nid: $id,\n subject: $subject,\n teacher: $teacher,\n class: $studentsClass,\n tag: $tag,\n isActive: $isActive,\n duration(minutes): $duration,\n room: $room,\n startTime: $startTime,\n $endTime\n}';
  }
}
