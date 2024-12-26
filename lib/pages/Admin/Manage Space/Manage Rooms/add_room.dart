import 'package:flutter/material.dart';
import 'package:smarn/models/building.dart';
import 'package:smarn/models/room.dart';
import 'package:smarn/models/room_type.dart';
import 'package:smarn/services/room_service.dart';
import 'package:smarn/services/building_service.dart';

class AddRoom extends StatefulWidget {
  const AddRoom({super.key});

  @override
  State<AddRoom> createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String description = '';
  int? capacity;
  RoomType type = RoomType.lecture;
  Building? selectedBuilding; // Selected building
  final RoomService _roomService = RoomService();
  final BuildingService _buildingService = BuildingService();

  List<Building> buildings = []; // List of buildings from the database
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadBuildings();
  }

  // Fetch all buildings
  Future<void> _loadBuildings() async {
    List<Building> fetchedBuildings = await _buildingService.getAllBuildings();
    setState(() {
      buildings = fetchedBuildings;
    });
  }

  Future<void> _addRoom() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedBuilding == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Building is required')),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    final newRoom = Room(
      name: name,
      type: type,
      description: description,
      capacity: capacity!,
      building: selectedBuilding!.id!, // Building ID
    );

    final result = await _roomService.addRoom(newRoom);

    setState(() {
      isSubmitting = false;
    });

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Room added successfully')),
      );
      Navigator.pop(context, newRoom); // This will return the new room to ManageRooms
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Failed to add room')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Room'),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: const Color(0xFF2A2A2A), // Dark card background
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0), // Rounded corners
              ),
              elevation: 8.0, // Shadow effect
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Room Name',
                          labelStyle: TextStyle(color: Colors.white),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Room name is required';
                          }
                          return null;
                        },
                        onChanged: (value) => name = value,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(color: Colors.white),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        onChanged: (value) => description = value,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Capacity',
                          labelStyle: TextStyle(color: Colors.white),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || int.tryParse(value) == null) {
                            return 'Enter a valid number for capacity';
                          }
                          return null;
                        },
                        onChanged: (value) => capacity = int.tryParse(value),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<RoomType>(
                        decoration: const InputDecoration(
                          labelText: 'Room Type',
                          labelStyle: TextStyle(color: Colors.white),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        dropdownColor: Colors.black,
                        style: const TextStyle(color: Colors.white),
                        value: type,
                        onChanged: (value) {
                          setState(() {
                            type = value!;
                          });
                        },
                        items: RoomType.values
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.name),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<Building>(
                        decoration: const InputDecoration(
                          labelText: 'Building',
                          labelStyle: TextStyle(color: Colors.white),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        dropdownColor: Colors.black,
                        style: const TextStyle(color: Colors.white),
                        value: selectedBuilding,
                        onChanged: (value) {
                          setState(() {
                            selectedBuilding = value!;
                          });
                        },
                        items: buildings.map((building) {
                          return DropdownMenuItem<Building>(
                            value: building,
                            child: Text(building.name),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: isSubmitting ? null : _addRoom,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 129, 77, 139),
                          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: isSubmitting
                            ? const CircularProgressIndicator()
                            : const Text('Add Room'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
