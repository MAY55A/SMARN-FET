import 'package:cloud_functions/cloud_functions.dart';
import 'package:smarn/models/room.dart';

class RoomService {
  final useFunctionsEmulator =
      FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);

  // Add a new room
  Future<Map<String, dynamic>> addRoom(Room room) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('addRoom');
      final response = await callable.call(<String, dynamic>{
        'roomData': room.toMap(),
      });

      return response.data;
    } catch (e) {
      return {'success': false, 'message': e};
    }
  }

  Future<Room?> getRoomDetails(String roomId) async {
    try {
      // Call function to get room details
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getRoom');
      final response = await callable.call(<String, dynamic>{'roomId': roomId});

      return Room.fromMap(response.data);
    } catch (e) {
      print('Error fetching room: $e');
      return null;
    }
  }

  Future<List<Room>> getAllRooms() async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getAllRooms');
      final response = await callable.call();

      // Ensure the response contains the list of roomes
      List<Room> roomsList = (response.data["rooms"] as List)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .map((s) => Room.fromMap(s))
          .toList();

      return roomsList;
    } catch (e) {
      print('Error fetching all rooms: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> updateRoom(String roomId, Room room) async {
    try {
      // Call function to update room
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('updateRoom');
      final response = await callable.call(<String, dynamic>{
        'roomId': roomId,
        'updateData': room.toMap(),
      });

      return response.data;
    } catch (e) {
      return {'success': false, 'message': e};
    }
  }

  Future<Map<String, dynamic>> deleteRoom(String roomId) async {
    try {
      // Call function to delete room
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('deleteRoom');
      final response = await callable.call(<String, dynamic>{'roomId': roomId});

      return response.data;
    } catch (e) {
      return {'success': false, 'message': e};
    }
  }

  Future<List<Room>> getRoomsByBuilding(String buildingId) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getRoomsByBuilding');
      final response =
          await callable.call(<String, dynamic>{'buildingId': buildingId});

      // Ensure the response contains the list of rooms
      List<Room> roomsList = (response.data["rooms"] as List)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .map((s) => Room.fromMap(s))
          .toList();

      return roomsList;
    } catch (e) {
      print('Error fetching rooms by building: $e');
      return [];
    }
  }
}
