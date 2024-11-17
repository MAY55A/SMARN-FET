import 'package:cloud_functions/cloud_functions.dart';
import 'package:smarn/models/change_request.dart';

class ChangeRequestService {
  final useFunctionsEmulator =
      FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);

  // Add a new changeRequest
  Future<Map<String, dynamic>> addChangeRequest(
      ChangeRequest changeRequest) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('createChangeRequest');
      final response = await callable.call(<String, dynamic>{
        'changeRequestData': changeRequest.toMap(),
      });

      return response.data;
    } catch (e) {
      return {'success': false, 'message': e};
    }
  }

  Future<ChangeRequest?> getChangeRequestDetails(String changeRequestId) async {
    try {
      // Call function to get changeRequest details
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getChangeRequest');
      final response = await callable
          .call(<String, dynamic>{'changeRequestId': changeRequestId});

      return ChangeRequest.fromMap(response.data);
    } catch (e) {
      print('Error fetching change request: $e');
      return null;
    }
  }

  Future<List<ChangeRequest>> getAllChangeRequests() async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getAllChangeRequests');
      final response = await callable.call();

      // Ensure the response contains the list of changeRequestes
      List<ChangeRequest> changeRequestsList =
          (response.data["changeRequests"] as List<dynamic>)
              .map((r) => ChangeRequest.fromMap(r))
              .toList();

      return changeRequestsList;
    } catch (e) {
      print('Error fetching all change requests: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> updateChangeRequest(
      String changeRequestId, ChangeRequest changeRequest) async {
    try {
      // Call function to update changeRequest
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('updateChangeRequest');
      final response = await callable.call(<String, dynamic>{
        'changeRequestId': changeRequestId,
        'updateData': changeRequest.toMap(),
      });

      return response.data;
    } catch (e) {
      return {'success': false, 'message': e};
    }
  }

  Future<Map<String, dynamic>> deleteChangeRequest(
      String changeRequestId) async {
    try {
      // Call function to delete changeRequest
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('deleteChangeRequest');
      final response = await callable
          .call(<String, dynamic>{'changeRequestId': changeRequestId});

      return response.data;
    } catch (e) {
      return {'success': false, 'message': e};
    }
  }
}

Future<List<ChangeRequest>> getChangeRequestsByTeacher(
    String teacherDocId) async {
  try {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('getChangeRequestsByTeacher');
    final response =
        await callable.call(<String, dynamic>{'teacherDocId': teacherDocId});

    // Ensure the response contains the list of changeRequests
    List<ChangeRequest> changeRequestsList =
        (response.data["changeRequests"] as List<dynamic>)
            .map((r) => ChangeRequest.fromMap(r))
            .toList();

    return changeRequestsList;
  } catch (e) {
    print("Error fetching teacher's change requests : $e");
    return [];
  }
}
