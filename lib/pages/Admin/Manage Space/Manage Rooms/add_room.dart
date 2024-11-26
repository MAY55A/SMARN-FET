import 'package:flutter/material.dart';
import 'package:smarn/models/building.dart';
import 'package:smarn/models/room.dart';
import 'package:smarn/models/room_type.dart';
<<<<<<< HEAD
=======
import 'package:smarn/services/room_service.dart';
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81

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
  Building building =
      Building(name: "b1", longName: "Building 1", description: "Main Building");
  final RoomService _roomService = RoomService();

  bool isSubmitting = false;

  Future<void> _addRoom() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isSubmitting = true;
    });

    final newRoom = Room(
      name: name,
      type: type,
      description: description,
      capacity: capacity!,
      building: building as String, // Adjust as per your model
    );

    final result = await _roomService.addRoom(newRoom);

    setState(() {
      isSubmitting = false;
    });

    if (result['success'] == true) {
      Navigator.pop(context, newRoom);
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
<<<<<<< HEAD
      backgroundColor: Colors.black, // Set background color to black
=======
      backgroundColor: Colors.black,
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
<<<<<<< HEAD
            // Allows scrolling when keyboard is open
=======
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Room Name',
<<<<<<< HEAD
                    labelStyle:
                        TextStyle(color: Colors.white), // White label text
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white), // White underline on focus
                    ),
                  ),
                  style:
                      const TextStyle(color: Colors.white), // White text color
=======
                    labelStyle: TextStyle(color: Colors.white),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81
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
<<<<<<< HEAD
                  dropdownColor:
                      Colors.black, // Black background for the dropdown
                  style:
                      const TextStyle(color: Colors.white), // White text color
=======
                  dropdownColor: Colors.black,
                  style: const TextStyle(color: Colors.white),
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81
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
                const SizedBox(height: 32),
                ElevatedButton(
<<<<<<< HEAD
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newRoom = Room(
                        name: name,
                        type: type,
                        description: description,
                        capacity: capacity,
                        building: building as String,
                      );
                      Navigator.pop(context, newRoom); // Return the new room
                    }
                  },
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(Colors.black),
                    backgroundColor: WidgetStateProperty.all(
                        const Color.fromARGB(255, 129, 77, 139)),
                    padding: WidgetStateProperty.all(const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32)),
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    )),
=======
                  onPressed: isSubmitting ? null : _addRoom,
                  child: isSubmitting
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text('Add Room'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 129, 77, 139),
                        ),
                        foregroundColor: MaterialStateProperty.all(Colors.black),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 16)),
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81
                  ),
                  child: const Text('Add Room'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
