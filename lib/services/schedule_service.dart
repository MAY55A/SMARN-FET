import 'package:cloud_functions/cloud_functions.dart';
import 'package:smarn/models/schedule.dart';

class ScheduleService {
  final useFunctionsEmulator =
      FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);

  // Add a new Schedule
  Future<Map<String, dynamic>> createSchedules(List<Schedule> schedules) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('createSchedules');
      final response = await callable.call(<String, dynamic>{
        'schedules': schedules.map((s) => s.toMap()).toList()
      });

      return response.data;
    } on FirebaseFunctionsException catch (e) {
      return {'success': false, 'message': e.message};
    }
  }

  Future<Schedule?> getSchedule(String scheduleId) async {
    try {
      // Call function to get Schedule details
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getSchedule');
      final response =
          await callable.call(<String, dynamic>{'scheduleId': scheduleId});

      return Schedule.fromMap(response.data);
    } catch (e) {
      print('Error fetching Schedule: $e');
      return null;
    }
  }

// Fetch all schedules for a given collection type ("TEA" for teachers, "CLA" for classes or "RM" for rooms)
  Future<List<Schedule>> getSchedulesForType(String type) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getSchedulesForType');
      final response = await callable.call(<String, dynamic>{
        'type': type,
      });

      // Ensure the response contains the list of Schedulees
      List<Schedule> schedulesList = (response.data["schedules"] as List)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .map((s) => Schedule.fromMap(s))
          .toList();

      return schedulesList;
    } catch (e) {
      print('Error fetching schedules: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> updateSchedule(
      String scheduleId, Schedule schedule) async {
    try {
      // Call function to update Schedule
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('updateSchedule');
      final response = await callable.call(<String, dynamic>{
        'scheduleId': scheduleId,
        'updateData': schedule.toMap(),
      });

      return response.data;
    } on FirebaseFunctionsException catch (e) {
      return {'success': false, 'message': e.message};
    }
  }

  Future<Map<String, dynamic>> deleteSchedule(
      String collection, String scheduleId) async {
    try {
      // Call function to delete Schedule
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('deleteSchedule');
      final response =
          await callable.call(<String, dynamic>{'scheduleId': scheduleId});

      return response.data;
    } on FirebaseFunctionsException catch (e) {
      return {'success': false, 'message': e.message};
    }
  }
}
