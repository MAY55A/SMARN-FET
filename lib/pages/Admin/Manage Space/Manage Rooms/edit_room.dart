import 'package:flutter/material.dart';
import 'package:smarn/models/building.dart';
import 'package:smarn/models/room.dart';
import 'package:smarn/models/room_type.dart';

class EditRoom extends StatefulWidget {
  final Room roomItem;
  const EditRoom({super.key, required this.roomItem});

  @override
  State<EditRoom> createState() => _EditRoomState();
}

class _EditRoomState extends State<EditRoom> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String description;
  late int capacity;
  late RoomType type;
  late Building building;

  @override
  void initState() {
    super.initState();
    name = widget.roomItem.name;
    description = widget.roomItem.description;
    capacity = widget.roomItem.capacity;
    type = widget.roomItem.type;
    building = widget.roomItem.building as Building;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Room'),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black, // Set background color to black
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            // Allows scrolling when keyboard is open
            child: Column(
              children: [
                // Room Name field
                TextFormField(
                  initialValue: name,
                  decoration: const InputDecoration(
                    labelText: 'Room Name',
                    labelStyle:
                        TextStyle(color: Colors.white), // White label text
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white), // White underline on focus
                    ),
                  ),
                  style:
                      const TextStyle(color: Colors.white), // White text color
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
                  dropdownColor:
                      Colors.black, // Black background for the dropdown
                  style:
                      const TextStyle(color: Colors.white), // White text color
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
                      final updatedRoom = Room(
                        id: widget.roomItem.id,
                        name: name,
                        type: type,
                        description: description,
                        capacity: capacity,
                        building: building as String,
                      );
                      Navigator.pop(
                          context, updatedRoom); // Return the updated room
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
                  ),
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
