import 'package:smarn/models/teacher.dart';

class Subject {
  String id;
  String name;
  String longName;
  String description;
  Set<Teacher> teachers;

  // Constructor
  Subject({
    required this.id,
    required this.name,
    required this.longName,
    required this.description,
    required this.teachers,
  });

  // Convert a Subject object into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'longName': longName,
      'description': description,
      'teachers': teachers
    };
  }

  // Create a Subject object from a Map
  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
        id: map['id'],
        name: map['name'],
        longName: map['longName'],
        description: map['description'],
        teachers: map['teachers']);
  }
}