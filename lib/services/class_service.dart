import 'package:cloud_functions/cloud_functions.dart';
import 'package:smarn/models/class.dart';

class ClassService {
  final useFunctionsEmulator =
      FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);

  // Add a new class
  Future<Map<String, dynamic>> createClass(Class studentsClass) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('addClass');
      final response = await callable.call(<String, dynamic>{
        'classData': studentsClass.toMap(),
      });

      return response.data;
    } catch (e) {
      return {'success': false, 'message': e};
    }
  }

  Future<Class?> getclassDetails(String className, String classKey) async {
    try {
      // Call function to get class details
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getClass');
      final response = await callable.call(
          <String, dynamic>{'className': className, 'classKey': classKey});

      return Class.fromMap(response.data);
    } catch (e) {
      print('Error fetching class: $e');
      return null;
    }
  }

  Future<List<Class>> getAllclasses() async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getAllClasses');
      final response = await callable.call();

      // Ensure the response contains the list of classes
      List<Class> classesList = (response.data["classes"] as List<dynamic>)
          .map((c) => Class.fromMap(c))
          .toList();

      return classesList;
    } catch (e) {
      print('Error fetching all classes: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> updateClass(
      String classId, Class studentsClass) async {
    try {
      // Call function to update class
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('updateClass');
      final response = await callable.call(<String, dynamic>{
        'classId': classId,
        'updateData': studentsClass.toMap(),
      });

      return response.data;
    } catch (e) {
      return {'success': false, 'message': e};
    }
  }

  Future<Map<String, dynamic>> changeClassKey(String classId) async {
    try {
      // Call function to change class key
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('regenerateClassKey');
      final response = await callable.call(<String, dynamic>{
        'classId': classId,
      });

      return response.data;
    } catch (e) {
      return {'success': false, 'message': e};
    }
  }

  Future<Map<String, dynamic>> deleteClass(String classId) async {
    try {
      // Call function to delete class
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('deleteClass');
      final response =
          await callable.call(<String, dynamic>{'classId': classId});

      return response.data;
    } catch (e) {
      return {'success': false, 'message': e};
    }
  }
}