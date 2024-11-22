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
    } catch (e) {
      return {'success': false, 'message': e};
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

Future<List<Activity>> getAllActivities() async {
  try {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('getAllActivities');
    final response = await callable.call();

    
    if (response.data["activities"] != null) {
      List<Activity> activitiesList =
          (response.data["activities"] as List<dynamic>)
              .map((r) => Activity.fromMap(r ?? {})) // Handle possible null 
              .toList();
      return activitiesList;
    } else {
      return [];
    }
  } catch (e) {
    print('Error fetching all activities: $e');
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
    } catch (e) {
      return {'success': false, 'message': e};
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
    } catch (e) {
      return {'success': false, 'message': e};
    }
  }
}

Future<List<Activity>> getActivitiesByTeacher(String teacherDocId) async {
  try {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('getActivitiesByTeacher');
    final response =
        await callable.call(<String, dynamic>{'teacherDocId': teacherDocId});

    // Ensure the response contains the list of activities
    List<Activity> activitiesList =
        (response.data["activities"] as List<dynamic>)
            .map((r) => Activity.fromMap(r))
            .toList();

    return activitiesList;
  } catch (e) {
    print("Error fetching teacher's activities : $e");
    return [];
  }
}