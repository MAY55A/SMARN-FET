import 'package:cloud_functions/cloud_functions.dart';
import 'package:smarn/models/subject.dart';

class SubjectService {
  final useFunctionsEmulator =
      FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);

  // Add a new Subject
  Future<Map<String, dynamic>> addSubject(Subject subject) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('addSubject');
      final response = await callable.call(<String, dynamic>{
        'subjectData': subject.toMap(),
      });

      return response.data;
    } on FirebaseFunctionsException catch (e) {
      return {'success': false, 'message': e.message};
    }
  }

  Future<Subject?> getSubjectDetails(String subjectId) async {
    try {
      // Call function to get Subject details
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getSubject');
      final response =
          await callable.call(<String, dynamic>{'subjectId': subjectId});

      return Subject.fromMap(response.data);
    } catch (e) {
      print('Error fetching Subject: $e');
      return null;
    }
  }

  Future<List<Subject>> getAllSubjects() async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getAllSubjects');
      final response = await callable.call();

      // Ensure the response contains the list of Subjectes
      List<Subject> subjectsList = (response.data["subjects"] as List)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .map((s) => Subject.fromMap(s))
          .toList();

      return subjectsList;
    } catch (e) {
      print('Error fetching all subjects: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> updateSubject(
      String subjectId, Subject subject) async {
    try {
      // Call function to update Subject
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('updateSubject');
      final response = await callable.call(<String, dynamic>{
        'subjectId': subjectId,
        'updateData': subject.toMap(),
      });

      return response.data;
    } on FirebaseFunctionsException catch (e) {
      return {'success': false, 'message': e.message};
    }
  }

  Future<Map<String, dynamic>> deleteSubject(String subjectId) async {
    try {
      // Call function to delete Subject
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('deleteSubject');
      final response =
          await callable.call(<String, dynamic>{'subjectId': subjectId});

      return response.data;
    } on FirebaseFunctionsException catch (e) {
      return {'success': false, 'message': e.message};
    }
  }
}
