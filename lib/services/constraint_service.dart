import 'package:cloud_functions/cloud_functions.dart';
import 'package:smarn/models/constraint.dart';


class ConstraintService {
  final useFunctionsEmulator =
      FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);

  // Add a new Time Constraint
  Future<Map<String, dynamic>> createTimeConstraint(TimeConstraint constraint) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('createTimeConstraint');
      final response = await callable.call(<String, dynamic>{
        'constraintData': constraint.toMap(),
      });

      return response.data;
    } on FirebaseFunctionsException catch (e) {
      return {'success': false, 'message': e.message};
    }
  }

    // Add a new Space Constraint
  Future<Map<String, dynamic>> createSpaceConstraint(SpaceConstraint constraint) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('createSpaceConstraint');
      final response = await callable.call(<String, dynamic>{
        'constraintData': constraint.toMap(),
      });

      return response.data;
    } on FirebaseFunctionsException catch (e) {
      return {'success': false, 'message': e.message};
    }
  }

      // Add a new Scheduling Rule
  Future<Map<String, dynamic>> createSchedulingRule(SchedulingRule constraint) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('createSchedulingRule');
      final response = await callable.call(<String, dynamic>{
        'constraintData': constraint.toMap(),
      });

      return response.data;
    } on FirebaseFunctionsException catch (e) {
      return {'success': false, 'message': e.message};
    }
  }

  Future<Constraint?> getConstraint(String constraintId) async {
    try {
      // Call function to get Constraint details
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getConstraint');
      final response = await callable.call(
          <String, dynamic>{'constraintId': constraintId});

      return Constraint.fromMap(response.data);
    } catch (e) {
      print('Error fetching Constraint: $e');
      return null;
    }
  }

  Future<List<Constraint>> getAllConstraints() async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getAllConstraints');
      final response = await callable.call();

      // Ensure the response contains the list of Constraintes
      List<Constraint> constraintsList = (response.data["constraints"] as List)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .map((c) => Constraint.fromMap(c))
          .toList();

      return constraintsList;
    } catch (e) {
      print('Error fetching all constraints: $e');
      return [];
    }
  }

  Future<List<Constraint>> getActiveConstraints() async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getActiveConstraints');
      final response = await callable.call();

      // Ensure the response contains the list of Constraintes
      List<Constraint> constraintsList = (response.data["constraints"] as List)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .map((c) => Constraint.fromMap(c))
          .toList();

      return constraintsList;
    } catch (e) {
      print('Error fetching all constraints: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> updateConstraint(
      String constraintId, Constraint constraint) async {
    try {
      // Call function to update Constraint
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('updateConstraint');
      final response = await callable.call(<String, dynamic>{
        'constraintId': constraintId,
        'updateData': constraint.toMap(),
      });

      return response.data;
    } catch (e) {
      return {'success': false, 'message': e};
    }
  }

  Future<Map<String, dynamic>> deleteConstraint(String constraintId) async {
    try {
      // Call function to delete Constraint
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('deleteConstraint');
      final response =
          await callable.call(<String, dynamic>{'constraintId': constraintId});

      return response.data;
    } catch (e) {
      return {'success': false, 'message': e};
    }
  }
}
