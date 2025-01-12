import 'package:cloud_functions/cloud_functions.dart';
import 'package:smarn/models/activity.dart';

class ActivityService {
  final useFunctionsEmulator =
      FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);

  // Add a new activity
  Future<Map<String, dynamic>> addActivity(Activity activity) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('addActivity');
      final response = await callable.call(<String, dynamic>{
        'activityData': activity.toMap(),
      });

      return response.data;
    } on FirebaseFunctionsException catch (e) {
      return {'success': false, 'message': e.message};
    }
  }

  Future<Map<String, dynamic>?> getActivityDetails(String activityId) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getActivity');
      final response =
          await callable.call(<String, dynamic>{'activityId': activityId});

      return response.data;
    } catch (e) {
      print('Error fetching Activity: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getAllActivities() async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getAllActivities');
      final response = await callable.call();
      List<Map<String, dynamic>> activitiesList =
          (response.data["activities"] as List)
              .map((item) => Map<String, dynamic>.from(item as Map))
              .toList();
      return activitiesList;
    } catch (e) {
      print('Error fetching all activities: $e');
      return [];
    }
  }

  Future<List<Activity>> getActiveActivities() async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getActiveActivities');
      final response = await callable.call();
      List<Activity> activitiesList = (response.data["activities"] as List)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .map((a) => Activity.fromMap(a))
          .toList();
      return activitiesList;
    } catch (e) {
      print('Error fetching active activities: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> updateActivity(
      String activityId, Activity activity) async {
    try {
      // Call function to update activity
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('updateActivity');
      final response = await callable.call(<String, dynamic>{
        'activityId': activityId,
        'updateData': activity.toMap(),
      });

      return response.data;
    } on FirebaseFunctionsException catch (e) {
      return {'success': false, 'message': e.message};
    }
  }

  Future<Map<String, dynamic>> deleteActivity(String activityId) async {
    try {
      // Call function to delete activity
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('deleteActivity');
      final response =
          await callable.call(<String, dynamic>{'activityId': activityId});

      return response.data;
    } on FirebaseFunctionsException catch (e) {
      return {'success': false, 'message': e.message};
    }
  }

  Future<List<Map<String, dynamic>>> getActivitiesByTeacher(
      String teacherDocId) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getActivitiesByTeacher');
      final response =
          await callable.call(<String, dynamic>{'teacherDocId': teacherDocId});

      List<Map<String, dynamic>> activitiesList =
          (response.data["activities"] as List)
              .map((item) => Map<String, dynamic>.from(item as Map))
              .toList();
      return activitiesList;
    } catch (e) {
      print("Error fetching teacher's activities : $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getActivitiesByClass(
      String classId) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getActivitiesByClass');
      final response =
          await callable.call(<String, dynamic>{'classId': classId});

      List<Map<String, dynamic>> activitiesList =
          (response.data["activities"] as List)
              .map((item) => Map<String, dynamic>.from(item as Map))
              .toList();
      return activitiesList;
    } catch (e) {
      print("Error fetching class's activities : $e");
      return [];
    }
  }
}
