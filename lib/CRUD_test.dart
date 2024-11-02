import 'package:smarn/services/teacher_service.dart';
import 'models/teacher.dart';

final teacherService = TeacherService();

void addTeacher() async {

  // Example of adding a teacher
  Teacher teacher = Teacher(
    name: 'Ahmed Ben Saleh',
    phone: '22 345 678',
    nbHours: 14,
    subjects: [],
    activities: []
  );

  await teacherService.createTeacherAccount("ahmed@gmail.com", "Ahmed1234", teacher);
}

void viewTeachers() async {
  // Example of getting all teachers
  List<Teacher> teachers = await teacherService.getTeachers();
  for (var t in teachers) {
    print("Teacher : ${t.name}");
  }
}
