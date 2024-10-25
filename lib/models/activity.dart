import 'package:smarn/models/activity_tag.dart';
import 'package:smarn/models/class.dart';
import 'package:smarn/models/room.dart';
import 'package:smarn/models/subject.dart';
import 'package:smarn/models/teacher.dart';

class Activity {
  String id;
  String name;
  Subject subject;
  Teacher teacher;
  Class studentsClass;
  bool isActive;
  int duration;
  ActivityTag tag;
  Room? room;

  // Constructor
  Activity({
    required this.id,
    required this.name,
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
      'name': name,
      'subject': subject,
      'teacher': teacher,
      'class': studentsClass,
      'tag': tag,
      'room': room,
      'isActive': isActive,
      'duration': duration,
    };
  }

  // Create a Activity object from a Map
  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
        id: map['id'],
        name: map['name'],
        subject: map['subject'],
        teacher: map['teacher'],
        studentsClass: map['class'],
        tag: map['tag'],
        isActive: map['isActive'],
        duration: map['duration'],
        room: map['room']);
  }
}
