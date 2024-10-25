import 'package:smarn/models/building.dart';
import 'package:smarn/models/room_type.dart';

class Room {
  String id;
  String name;
  RoomType type;
  String description;
  int capacity;
  Building building;

  // Constructor
  Room(
      {required this.id,
      required this.name,
      required this.type,
      required this.description,
      required this.capacity,
      required this.building});

  // Convert a Room object into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
      'capacity': capacity,
      'building': building
    };
  }

  // Create a Room object from a Map
  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
        id: map['id'],
        name: map['name'],
        type: map['type'],
        description: map['description'],
        capacity: map['capacity'],
        building: map['building']);
  }
}
