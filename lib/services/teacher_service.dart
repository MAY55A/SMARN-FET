import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smarn/models/subject.dart';
import 'package:smarn/models/teacher.dart';
import 'package:smarn/services/auth_service.dart';
import 'package:smarn/services/subject_service.dart';

class TeacherService {
  final AuthService _authService = AuthService();
  final useFunctionsEmulator =
      FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);

  // Add a new teacher
  Future<dynamic> createTeacher(
      String email, String password, Teacher teacher) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('createTeacherAccount');
      final response = await callable.call(<String, dynamic>{
        'email': email,
        'password': password,
        'teacher': teacher.toMap(),
      });
      return response.data;
    } catch (e) {
      return 'Error creating teacher: $e';
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      User? user =
          await _authService.signInWithEmailAndPassword(email, password);
      if (await _authService.getUserRole(user) == 'teacher') {
        return {'success': true, 'message': "Teacher logged in successfully."};
      } else {
        _authService.signOut();
        return {
          'success': false,
          'message': "This form is only for teacher access."
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': "Login failed. Please check your credentials"
      };
    }
  }

  Future<Teacher?> getTeacher(String teacherDocId) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getTeacher');
      final response =
          await callable.call(<String, dynamic>{'teacherDocId': teacherDocId});

      return Teacher.fromMap(response.data);
    } catch (e) {
      print('Error fetching teacher: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getAllTeachers() async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getAllTeachers');
      final response = await callable.call();

      List<Map<String, dynamic>> teachersList = [];
      for (Map<String, dynamic> t in response.data["teachers"]) {
        teachersList
            .add({"id": t["id"], "teacher": Teacher.fromMap(t["teacher"])});
      }
      return teachersList;
    } catch (e) {
      print('Error fetching all teachers: $e');
      return [];
    }
  }

  Future<Teacher?> fetchTeacherData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        return await getTeacher(currentUser.uid);
      }
      return null;
    } catch (e) {
      print("Error fetching teacher data: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>> updateTeacher(
      String teacherDocId, Teacher teacher) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('updateTeacherAccount');
      final response = await callable.call(<String, dynamic>{
        'teacherDocId': teacherDocId,
        'updateData': teacher.toMap(),
      });

      // Log the full response
      print('Update Response: ${response.data}');
      return response.data;
    } catch (e) {
      print("Error updating teacher: $e");
      return {'success': false, 'message': "Error updating teacher: $e."};
    }
  }

  Future<Map<String, dynamic>> deleteTeacher(String teacherDocId) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('deleteTeacherAccount');
      final response =
          await callable.call(<String, dynamic>{'teacherDocId': teacherDocId});

      // Log the full response
      print('Delete Response: ${response.data}');

      if (response.data != null && response.data['success'] == true) {
        return {'success': true, 'message': 'Teacher deleted successfully.'};
      } else {
        return {'success': false, 'message': 'Failed to delete teacher.'};
      }
    } catch (e) {
      print("Error deleting teacher: $e");
      return {'success': false, 'message': "Error deleting teacher: $e."};
    }
  }
  
  // Fetch teachers filtered by subject name
Future<List<Map<String, dynamic>>> getTeachersBySubject(String? subjectName) async {
  try {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getTeachersBySubject');
    
    // Fetch all subjects locally to find the subject ID matching the name
    final allSubjects = await SubjectService().getAllSubjects(); // Assuming this method exists
    final subject = allSubjects.firstWhere(
      (subject) => subject.name.toLowerCase() == (subjectName?.toLowerCase() ?? ''),
      orElse: () => Subject(id: '', name: ''), // Fallback to an empty Subject
    );
    // Proceed with the backend call using the matched subject ID
    final response = await callable.call(<String, dynamic>{
      'subjectId': subject.id, // Use the matched subject ID
    });

    // Check if the response contains the 'teachers' key and is not null
    if (response.data != null && response.data["teachers"] != null) {
      List<Map<String, dynamic>> teachersList = [];
      for (Map<String, dynamic> t in response.data["teachers"]) {
        teachersList.add({
          "id": t["id"],
          "teacher": Teacher.fromMap(t["teacher"]),
        });
      }
      return teachersList;
    } else {
      print('No teachers data found.');
      return [];
    }
  } catch (e) {
    print('Error fetching teachers by subject name: $e');
    return [];
  }
}

}
