import 'package:smarn/models/activity.dart';
import 'package:smarn/models/subject.dart';

class Teacher {
  String id;
  String name;
  String email;
  String phone;
  int nbHours;
  String password;
  Set<Subject> subjects;
  Set<Activity> activities;

  // Constructor
  Teacher(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.nbHours,
      required this.password,
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
      'password': password,
      'subjects': subjects,
      'activities': activities
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
        password: map['password'],
        subjects: map['subjects'],
        activities: map['activities']);
  }
}
