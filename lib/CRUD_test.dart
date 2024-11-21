import 'package:smarn/models/activity.dart';
import 'package:smarn/models/activity_tag.dart';
import 'package:smarn/models/building.dart';
import 'package:smarn/models/change_request.dart';
import 'package:smarn/models/class.dart';
import 'package:smarn/models/room.dart';
import 'package:smarn/models/room_type.dart';
import 'package:smarn/models/subject.dart';
import 'package:smarn/services/activity_service.dart';
import 'package:smarn/services/admin_service.dart';
import 'package:smarn/services/building_service.dart';
import 'package:smarn/services/change_request_service.dart';
import 'package:smarn/services/class_service.dart';
import 'package:smarn/services/room_service.dart';
import 'package:smarn/services/subject_service.dart';
import 'package:smarn/services/teacher_service.dart';
import 'models/teacher.dart';
import 'services/auth_service.dart';

final teacherService = TeacherService();
final adminService = AdminService();
final classService = ClassService();
final authService = AuthService();
final subjectService = SubjectService();
final buildingService = BuildingService();
final roomService = RoomService();
final activityService = ActivityService();
final changeRequestService = ChangeRequestService();

void addTeacher() async {
  // Example of adding a teacher
  Teacher teacher = Teacher(
      name: 'Ahlem Mbarki', phone: '11 222 333', nbHours: 11, subjects: []);

  await teacherService.createTeacher("ahlem@gmail.com", "Ahlem1234", teacher);
}

void addTeacher2() async {
  // Example of adding a teacher
  Teacher teacher = Teacher(
      name: 'sarra ammar', phone: '11 222 333', nbHours: 11, subjects: []);
  var res = await teacherService.createTeacher(
      "sarra@gmail.com", "Sarra1234", teacher);
  print(res['message']);
}

void setAdmin() async {
  await adminService.setAdminRole("ZuNO578VqtedTtPpv7wZRCgZSeK2");
}

void viewTeachers() async {
  // Example of getting all teachers
  List<Map<String, dynamic>> teachers = await teacherService.getAllTeachers();
  for (var t in teachers) {
    print(t);
    print("Teacher document id: ${t["id"]}");
    print("Teacher object: ${t["teacher"]}");
  }
}

void getTeacher(String id) async {
  Teacher? teacher = await teacherService.getTeacher(id);
  print(teacher?.name);
}

void updateTeacher(String id) async {
  // Example of updating a teacher
  Teacher teacher = Teacher(
      id: "TEA003",
      email: "ahlem@gmail.com",
      name: 'Ahlem Mbarki',
      phone: '11 222 444',
      nbHours: 12,
      subjects: []);

  await teacherService.updateTeacher(id, teacher);
}

void classCrud() async {
  // Example of CRUD operations on classes
  Class class1 = Class(
      name: 'DSI3.1',
      longName: "Developpement de Systemes d'Information 3ème année Groupe 1",
      nbStudents: 31);
  var res = await classService.createClass(class1);
  print(res["message"]);
  List<Class> classes = await classService.getAllclasses();
  for (var c in classes) {
    print(c);
  }
}

void changePassword() async {
  String res = await authService.updateUserCredentials(
      currentPassword: "Adminkey", newPassword: "adminkey");
  print(res);
}

void subjectCrud() async {
  // Example of CRUD operations on subjects
  Subject subject = Subject(
    name: 'SOA',
    longName: "Service Oriented Architecture",
    description: "Fundamental principles of SOA and its composants",
  );
  var res = await subjectService.addSubject(subject);
  print(res["message"]);
  List<Subject> subjects = await subjectService.getAllSubjects();
  for (var s in subjects) {
    print(s);
  }
}
/*
void updateQualifiedSubjects(String teacherDocId) async {
  List<String> subjects = ["SUB001", "SUB002", "SUB003"];
  var res = await teacherService.updateTeacherSubjects(teacherDocId, subjects);
  print(res["message"]);
}*/

void buildingCrud() async {
  // Example of CRUD operations on buildings
  Building b = Building(
    name: 'GI',
    longName: "Gestion d'Info",
    description: "lorem ipsum",
  );
  var res = await buildingService.addBuilding(b);
  print(res["message"]);

  print(await buildingService.getAllBuildings());
}

void roomCrud() async {
  // Example of CRUD operations on rooms
  Room r = Room(
    name: 'LI1.1',
    type: RoomType.lab,
    description: "Labo d'info n°1",
    capacity: 30,
    building: "BLD001",
  );
  var res = await roomService.addRoom(r);
  print(res["message"]);
  print(await roomService.getRoomDetails("LI1.1"));
  print(await roomService.getRoomsByBuilding("BLD001"));
}

void activityCrud() async {
  // Example of CRUD operations on activities
  Activity a = Activity(
    subject: 'SUB001',
    studentsClass: 'CLA001',
    teacher: 'TEA003',
    tag: ActivityTag.lab,
    duration: 120, // 120 minutes = 2 hours
  );
  var res = await activityService.addActivity(a);
  print(res["message"]);
  print(await activityService.getActivityDetails("ACT001"));

  Activity updatedAct = Activity(
      subject: 'SUB001',
      studentsClass: 'CLA001',
      teacher: 'TEA003',
      tag: ActivityTag.lab,
      duration: 120,
      isActive: false);
  print(await activityService.updateActivity("ACT001", updatedAct));
}

void requestCrud() async {
  // Example of CRUD operations on change requests
  ChangeRequest c = ChangeRequest(
    content: 'make monday evening free',
    reason: 'I have regular appointments with the doctor',
    teacher: 'TEA003',
  );
  var res = await changeRequestService.addChangeRequest(c);
  print(res["message"]);
  print(await changeRequestService.getChangeRequestDetails("CHRQ001"));
}

void teacherCrud() async {
  print(await teacherService.getTeachersBySubject("SUB001"));

  print(await teacherService.deleteTeacher("or4OKe8jyDMWpUGsrL9AqaoChL83"));
}

void deleteTeacherTest1() async {
  // Test: Deleting teacher with ID drM5ToiveZd2M7CwN0gsn5yfv913
  String teacherId = "drM5ToiveZd2M7CwN0gsn5yfv913";
  var res = await teacherService.deleteTeacher(teacherId);
  print("Delete result for teacher $teacherId: ${res['message']}");
}
/*
void deleteTeacherTest2() async {
  // Test: Deleting teacher with ID rLN8KY5YaLfsmArRRtGeEfmgAg03
  String teacherId = "rLN8KY5YaLfsmArRRtGeEfmgAg03";
  var res = await teacherService.deleteTeacher(teacherId);
  print("Delete result for teacher $teacherId: ${res['message']}");
}
*/
