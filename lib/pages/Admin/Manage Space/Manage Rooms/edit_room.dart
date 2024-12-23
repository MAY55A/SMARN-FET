import 'package:flutter/material.dart';
import 'package:smarn/models/building.dart';
import 'package:smarn/models/room.dart';
import 'package:smarn/models/room_type.dart';
import 'package:smarn/services/room_service.dart';
import 'package:smarn/services/building_service.dart';

class EditRoom extends StatefulWidget {
  final Room roomItem;

  const EditRoom({super.key, required this.roomItem});

  @override
  State<EditRoom> createState() => _EditRoomState();
}

class _EditRoomState extends State<EditRoom> {
  final _formKey = GlobalKey<FormState>();
  final RoomService _roomService = RoomService();
  final BuildingService _buildingService = BuildingService();

  late String name;
  late String description;
  late int capacity;
  late RoomType type;
  late Building selectedBuilding;
  bool isLoading = false;
  bool isBuildingsLoading = true;

  List<Building> buildings = [];

  @override
  void initState() {
    super.initState();
    name = widget.roomItem.name;
    description = widget.roomItem.description;
    capacity = widget.roomItem.capacity;
    type = widget.roomItem.type;

    // Load buildings
    _loadBuildings();
  }

  Future<void> _loadBuildings() async {
    List<Building> fetchedBuildings = await _buildingService.getAllBuildings();
    setState(() {
      buildings = fetchedBuildings;
      isBuildingsLoading = false;

      // Find the Building object based on the building ID (String)
      selectedBuilding = buildings.firstWhere(
        (building) => building.id == widget.roomItem.building, // Match with building ID
        orElse: () => buildings.first, // Fallback to the first building if not found
      );
    });
  }

  Future<void> _updateRoom() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      final updatedRoom = Room(
        id: widget.roomItem.id,
        name: name,
        type: type,
        description: description,
        capacity: capacity,
        building: selectedBuilding.id!, // Use the ID of the selected building
      );

      if (!updatedRoom.equals(widget.roomItem)) {
        final result = await _roomService.updateRoom(widget.roomItem.id!, updatedRoom);

        if (result['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Room updated successfully!')),
          );
          Navigator.pop(context, updatedRoom);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${result['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No changes were made to the room')),
        );
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Room'),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading || isBuildingsLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Room Name field
                      TextFormField(
                        initialValue: name,
                        decoration: const InputDecoration(
                          labelText: 'Room Name',
                          labelStyle: TextStyle(color: Colors.white),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the room name';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          name = value;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Description field
                      TextFormField(
                        initialValue: description,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(color: Colors.white),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        onChanged: (value) {
                          description = value;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Capacity field
                      TextFormField(
                        initialValue: capacity.toString(),
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
                          if (value == null || value.isEmpty) {
                            return 'Please enter the room capacity';
                          }
                          if (int.tryParse(value) == null || int.tryParse(value)! <= 0) {
                            return 'Capacity must be a positive number';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          capacity = int.tryParse(value) ?? 0;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Room Type dropdown
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
                      // Building dropdown
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
                        items: buildings
                            .map((building) => DropdownMenuItem(
                                  value: building,
                                  child: Text(building.name),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 32),
                      // Submit button
                      ElevatedButton(
                        onPressed: _updateRoom,
                        child: const Text('Save Changes'),
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(Colors.black),
                          backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 129, 77, 139),
                          ),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
