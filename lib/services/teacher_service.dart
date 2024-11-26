import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smarn/models/teacher.dart';
import 'package:smarn/services/auth_service.dart';

class TeacherService {
  final AuthService _authService = AuthService();
  final useFunctionsEmulator =
      FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);

  // Add a new teacher
 
 
 Future<Map<String, dynamic>> createTeacher(
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
    if (e is FirebaseFunctionsException) {
      // Log Firebase-specific errors
      print('FirebaseFunctionsException: ${e.code}, ${e.message}');
      return {'success': false, 'message': e.message ?? 'An error occurred'};
    }
    // Log any other unexpected errors
    print('Unexpected error: $e');
    return {'success': false, 'message': e.toString()};
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
          'message': "This form in only for teacher access."
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': "Login failed. Please check your credentials"
      };
    }
  }

  /// Fetches the authenticated teacher's data from Firebase or Cloud Functions.
  Future<Teacher?> fetchTeacherData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("No authenticated user found.");
      }

      // Assuming `getTeacher` fetches teacher data based on their UID.
      return await getTeacher(currentUser.uid);
    } catch (e) {
      print("Error fetching teacher data: $e");
      return null;
    }
  }

  Future<Teacher?> getTeacher(String teacherDocId) async {
    try {
      // Call function to get teacher details
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

      // Ensure the response contains the list of teachers
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

  Future<Map<String, dynamic>> updateTeacher(
      String teacherDocId, Teacher teacher) async {
    try {
      // Call function to update teacher
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('updateTeacherAccount');
      final response = await callable.call(<String, dynamic>{
        'teacherDocId': teacherDocId,
        'updateData': teacher.toMap(),
      });

      return response.data;
    } catch (e) {
      return {'success': false, 'message': "Error updating teacher: $e."};
    }
  }

  /// Updates the subjects of a teacher in the database.
  ///
  /// This function calls the 'updateTeacherSubjects' Cloud Function to update the subjects of a teacher.
  /// It takes two parameters:
  /// - [teacherDocId]: A string representing the document ID of the teacher in the database.
  /// - [newSubjects]: A list of strings representing the IDs of the new subjects to be assigned to the teacher.
  ///
  /// The function returns a [Map<String, dynamic>] containing the following keys:
  /// - 'success': A boolean indicating whether the update was successful.
  /// - 'message': A string providing a message about the outcome of the update.
  ///
  /// If an error occurs during the update, the function returns a map with 'success' set to false and
  /// a descriptive 'message' indicating the error.
  Future<Map<String, dynamic>> updateTeacherSubjects(
      String teacherDocId, List<String> newSubjects) async {
    try {
      // Call function to update teacher
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('updateTeacherSubjects');
      final response = await callable.call(<String, dynamic>{
        'teacherDocId': teacherDocId,
        'updatedSubjects': newSubjects,
      });

      return response.data;
    } catch (e) {
      return {'success': false, 'message': "Error updating teacher: $e."};
    }
  }

  Future<Map<String, dynamic>> deleteTeacher(String teacherDocId) async {
    try {
      // Call function to delete teacher
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('deleteTeacherAccount');
      final response =
          await callable.call(<String, dynamic>{'teacherDocId': teacherDocId});

      return response.data;
    } catch (e) {
      return {'success': false, 'message': "Error deleting teacher: $e."};
    }
  }

  Future<List<Map<String, dynamic>>> getTeachersBySubject(
      String subjectId) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getTeachersBySubject');
      final response =
          await callable.call(<String, dynamic>{'subjectId': subjectId});

      // Ensure the response contains the list of teachers
      List<Map<String, dynamic>> teachersList = [];
      for (Map<String, dynamic> t in response.data["teachers"]) {
        teachersList
            .add({"id": t["id"], "teacher": Teacher.fromMap(t["teacher"])});
      }
      return teachersList;
    } catch (e) {
      print('Error fetching teachers teaching this subject : $e');
      return [];
    }
  }
}
