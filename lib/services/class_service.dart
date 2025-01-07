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
    } on FirebaseFunctionsException catch (e) {
      return {'success': false, 'message': e.message};
    }
  }

  Future<Class?> getClassDetails(String className, String classKey) async {
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

  Future<List<Class>> getAllClasses() async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getAllClasses');
      final response = await callable.call();

      // Ensure the response contains the list of classes
      List<Class> classesList = (response.data["classes"] as List)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .map((c) => Class.fromMap(c))
          .toList();

      return classesList;
    } catch (e) {
      print('Error fetching all classes: $e');
      return [];
    }
  }

  Future<List<String>> getAllClassesNames() async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getAllClassesNames');
      final response = await callable.call();

      return List<String>.from(response.data["classes"]);
    } catch (e) {
      print('Error fetching all classes names: $e');
      return [];
    }
  }

  Future<Map<String, int>> getAllClassesNbStudents() async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getAllClassesNbStudents');
      final response = await callable.call();
      var classesList = response.data["classes"] as List;
      Map<String, int> nbStudentsPerClass = {};
      for (var classMap in classesList) {
        classMap = Map<String, dynamic>.from(classMap);
        nbStudentsPerClass[classMap["id"]] = classMap["nbStudents"] as int;
      }
      return nbStudentsPerClass;
    } catch (e) {
      print('Error fetching number of students for all classes: $e');
      return {};
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
