import 'package:smarn/models/activity.dart';
import 'package:smarn/models/subject.dart';

class Teacher {
  String? id;
  String name;
  String? email;
  String phone;
  int nbHours;
  List<Subject> subjects;
  List<Activity> activities;

  // Constructor
  Teacher(
      {this.id,
      required this.name,
      this.email,
      required this.phone,
      required this.nbHours,
      required this.subjects,
      required this.activities});

  // Convert a Teacher object into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'nbHours': nbHours,
      'subjects': subjects.map((s) => s.toMap()).toList(),
      'activities': activities.map((a) => a.toMap()).toList()
    };
  }

  // Create a Teacher object from a Map
  factory Teacher.fromMap(Map<String, dynamic> map) {
    return Teacher(
        id: map['id'],
        name: map['name'],
        email: map['email'],
        phone: map['phone'],
        nbHours: map['nbHours'],
        subjects: (map['subjects'] as List)
            .map((subjectMap) => Subject.fromMap(subjectMap))
            .toList(),
        activities: (map['activities'] as List)
            .map((activityMap) => Activity.fromMap(activityMap))
            .toList());
  }
}
