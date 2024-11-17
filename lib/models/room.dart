import 'package:smarn/models/building.dart';
import 'package:smarn/models/room_type.dart';

class Room {
  String? id;
  String name;
  RoomType type;
  String description;
  int capacity;
  String building;

  // Constructor
  Room(
      {this.id,
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
      'type': type.name,
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
        type: RoomType.values.firstWhere((e) => e.name == map['type']),
        description: map['description'],
        capacity: map['capacity'],
        building: map['building']);
  }

  @override
  String toString() {
    return "room $id : \n name: $name\n type: $type\ndescription: $description\n capacity: $capacity\n building: $building";
  }
}
