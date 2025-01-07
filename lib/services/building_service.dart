import 'package:cloud_functions/cloud_functions.dart';
import 'package:smarn/models/building.dart';

class BuildingService {
  final useFunctionsEmulator =
      FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);

  // Add a new building
  Future<Map<String, dynamic>> addBuilding(Building building) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('addBuilding');
      final response = await callable.call(<String, dynamic>{
        'buildingData': building.toMap(),
      });

      return response.data;
    } on FirebaseFunctionsException catch (e) {
      return {'success': false, 'message': e.message};
    }
  }

  Future<Building?> getBuildingDetails(String buildingId) async {
    try {
      // Call function to get building details
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getBuilding');
      final response =
          await callable.call(<String, dynamic>{'buildingId': buildingId});

      return Building.fromMap(response.data);
    } catch (e) {
      print('Error fetching building: $e');
      return null;
    }
  }

  Future<List<Building>> getAllBuildings() async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getAllBuildings');
      final response = await callable.call();

      // Ensure the response contains the list of buildings
      List<Building> buildingsList = (response.data["buildings"] as List)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .map((s) => Building.fromMap(s))
          .toList();

      return buildingsList;
    } catch (e) {
      print('Error fetching all buildings: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> updateBuilding(
      String buildingId, Building building) async {
    try {
      // Call function to update building
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('updateBuilding');
      final response = await callable.call(<String, dynamic>{
        'buildingId': buildingId,
        'updateData': building.toMap(),
      });

      return response.data;
    } catch (e) {
      return {'success': false, 'message': e};
    }
  }

  Future<Map<String, dynamic>> deleteBuilding(String buildingId) async {
    try {
      // Call function to delete building
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('deleteBuilding');
      final response =
          await callable.call(<String, dynamic>{'buildingId': buildingId});

      return response.data;
    } catch (e) {
      return {'success': false, 'message': e};
    }
  }
}
