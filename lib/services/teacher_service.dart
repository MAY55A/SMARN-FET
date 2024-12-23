import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smarn/models/subject.dart';
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
    } on FirebaseFunctionsException catch (e) {
      return {'success': false, 'message': e.message};
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

  Future<String?> getTeacherName(String teacherId) async {
    try {
      // Call function to get teacher details
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getTeacherName');
      final response =
          await callable.call(<String, dynamic>{'teacherId': teacherId});

      return response.data;
    } catch (e) {
      print('Error fetching teacher name: $e');
      return null;
    }
  }

  /// Fetches the authenticated teacher's data from Firebase or Cloud Functions.
  Future<Teacher?> fetchTeacherData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("No authenticated user found.");
      }
      return await getTeacher(currentUser.uid);
    } catch (e) {
      print("Error fetching teacher data: $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getAllTeachers() async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getAllTeachers');
      final response = await callable.call();

      // Ensure the response contains the list of teachers
      List<Map<String, dynamic>> teachersList = (response.data["teachers"]
              as List)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .map((t) => {
                "id": t["id"],
                "teacher":
                    Teacher.fromMap(Map<String, dynamic>.from(t["teacher"])),
              })
          .toList();
      return teachersList;
    } catch (e) {
      print('Error fetching all teachers: $e');
      return [];
    }
  }

  Future<List<String>> getAllTeachersNames() async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getAllTeachersNames');
      final response = await callable.call();
      List<String> teachersList = List<String>.from(response.data["teachers"]);
      return teachersList;
    } catch (e) {
      print('Error fetching all teachers names: $e');
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
    } on FirebaseFunctionsException catch (e) {
      return {'success': false, 'message': e.message};
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
    } on FirebaseFunctionsException catch (e) {
      return {'success': false, 'message': e.message};
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
    } on FirebaseFunctionsException catch (e) {
      return {'success': false, 'message': e.message};
    }
  }

  Future<List<Map<String, String>>> getTeachersBySubject(
      String subjectId) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getTeachersBySubject');
      final response = await callable.call(<String, dynamic>{'subjectId': subjectId});

      // Ensure the response contains the list of teachers
      List<Map<String, String>> teachersList =
          (response.data["teachers"] as List)
              .map((item) => Map<String, String>.from(item as Map))
              .map((t) => {
                    "id": t["id"] as String,
                    "name": t["name"] as String,
                  })
              .toList();
      return teachersList;
    } catch (e) {
      print('Error fetching teachers for subject: $e');
      return []; // Return an empty list in case of error
    }
  }
}
