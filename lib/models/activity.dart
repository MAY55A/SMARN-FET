import 'package:smarn/models/activity_tag.dart';

class Activity {
  String? id;
  String subject;
  String teacher;
  String studentsClass;
  bool isActive;
  // duration in minutes
  int duration;
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
    this.room,
    this.isActive = true,
  });

  // Convert a Activity object into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'teacher': teacher,
      'class': studentsClass,
      'tag': tag.name,
      'room': room,
      'isActive': isActive,
      'duration': duration,
    };
  }

  // Create a Activity object from a Map
  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
        id: map['id'],
        subject: map['subject'],
        teacher: map['teacher'],
        studentsClass: map['class'],
        tag: ActivityTag.values.firstWhere((e) => e.name == map['tag']),
        isActive: map['isActive'],
        duration: map['duration'],
        room: map['room']);
  }

  @override
  String toString() {
    return 'Activity{\nid: $id,\n subject: $subject,\n teacher: $teacher,\n class: $studentsClass,\n tag: $tag,\n isActive: $isActive,\n duration(minutes): $duration,\n room: $room\n}';
  }
}