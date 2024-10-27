import 'package:smarn/models/activity_tag.dart';
import 'package:smarn/models/class.dart';
import 'package:smarn/models/room.dart';
import 'package:smarn/models/subject.dart';
import 'package:smarn/models/teacher.dart';

class Activity {
  String? id;
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
    this.id,
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
      'subject': subject.toMap(),
      'teacher': teacher.toMap(),
      'class': studentsClass.toMap(),
      'tag': tag.name,
      'room': room?.toMap(),
      'isActive': isActive,
      'duration': duration,
    };
  }

  // Create a Activity object from a Map
  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
        id: map['id'],
        name: map['name'],
        subject: Subject.fromMap(map['subject']),
        teacher: Teacher.fromMap(map['teacher']),
        studentsClass: Class.fromMap(map['class']),
        tag: ActivityTag.values.firstWhere((e) => e.name == map['tag']),
        isActive: map['isActive'],
        duration: map['duration'],
        room: Room.fromMap(map['room']));
  }
}
