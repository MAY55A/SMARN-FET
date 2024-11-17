import 'package:flutter/material.dart';
import 'package:smarn/models/building.dart';
import 'package:smarn/models/room.dart';
import 'package:smarn/models/room_type.dart';
import 'package:smarn/pages/widgets/canstants.dart';

class AddRoom extends StatefulWidget {
  const AddRoom({super.key});

  @override
  State<AddRoom> createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String description = '';
  int capacity = 0;
  RoomType type = RoomType.lecture;
  Building building =
      Building(name: "b1", longName: "build", description: "build1");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Room'),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,  // Set background color to black
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView( // Allows scrolling when keyboard is open
            child: Column(
              children: [
                // Room Name field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Room Name',
                    labelStyle: TextStyle(color: Colors.white),  // White label text
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),  // White underline on focus
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),  // White text color
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter room name';
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
                      return 'Please enter capacity';
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
                  dropdownColor: Colors.black,  // Black background for the dropdown
                  style: const TextStyle(color: Colors.white),  // White text color
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
                // Submit button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newRoom = Room(
                        name: name,
                        type: type,
                        description: description,
                        capacity: capacity,
                        building: building,
                      );
                      Navigator.pop(context, newRoom); // Return the new room
                    }
                  },
                  child: const Text('Add Room'),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 129, 77, 139)),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 32)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    )),
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
