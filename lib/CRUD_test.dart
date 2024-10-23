import 'package:smarn/services/teacherService.dart';
import 'models/teacher.dart';

final teacherService = Teacherservice();

void add_teacher() async {

  // Example of adding a teacher
  Map<String, dynamic> teacher = {
    'name': 'Ahlem Ben Saleh',
    'email': 'ahlem@gmail.com',
    'phone': '22 345 678',
    'nbHours': 14,
    'password': '2222'
  };

  await teacherService.addTeacherWithCustomId(teacher);
}

void view_teachers() async {
  // Example of getting all teachers
  List<Teacher> teachers = await teacherService.getTeachers();
  teachers.forEach((t) {
    print("Teacher : " + t.name);
  });
}
