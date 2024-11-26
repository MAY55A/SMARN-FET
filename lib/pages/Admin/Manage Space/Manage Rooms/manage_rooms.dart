import 'package:flutter/material.dart';
import 'package:smarn/models/building.dart';
import 'package:smarn/models/room.dart';
import 'package:smarn/models/room_type.dart';
import 'add_room.dart'; // Import the AddRoom screen
import 'edit_room.dart'; // Import the EditRoom screen

class ManageRooms extends StatefulWidget {
  const ManageRooms({super.key});

  @override
  State<ManageRooms> createState() => _ManageRoomsState();
}

class _ManageRoomsState extends State<ManageRooms> {
  // Static data (rooms)
  List<Room> rooms = [
    Room(
        id: '1',
        name: 'Room 101',
        type: RoomType.lecture,
        description: 'Large lecture room',
        capacity: 50,
        building: Building(name: "b1", longName: "build", description: "build1")
            as String),
    Room(
      id: '2',
      name: 'Room 102',
      type: RoomType.lab,
      description: 'Computer lab',
      capacity: 30,
      building: Building(name: "b1", longName: "build", description: "build1")
          as String,
    ),
    Room(
      id: '3',
      name: 'Room 103',
      type: RoomType.auditorium,
      description: 'Auditorium with projector',
      capacity: 100,
      building: Building(name: "b1", longName: "build", description: "build1")
          as String,
    ),
  ];

  List<Room> filteredRooms = []; // List to hold filtered rooms
  String filterName = ''; // Filter for room name

  @override
  void initState() {
    super.initState();
    // Initially show all rooms
    filteredRooms = rooms;
  }

  // Function to filter rooms based on the current filters
  void _filterRooms() {
    setState(() {
      filteredRooms = rooms
          .where((roomItem) =>
              roomItem.name.toLowerCase().contains(filterName.toLowerCase()))
          .toList();
    });
  }

  // Function to handle edit room and navigate to EditRoom
  void _editRoom(Room roomItem) async {
    final updatedRoom = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditRoom(roomItem: roomItem),
      ),
    );

    if (updatedRoom != null) {
      setState(() {
        int index = rooms.indexWhere((r) => r.id == updatedRoom.id);
        if (index != -1) {
          rooms[index] = updatedRoom;
        }
      });
    }
  }

  // Function to handle delete room
  void _deleteRoom(Room roomItem) {
    setState(() {
      filteredRooms.remove(roomItem);
      rooms.remove(roomItem);
    });
    print("Deleted Room: ${roomItem.name}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Manage Rooms'),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Filter Section combined with Search
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Search Bar for Room Name
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      filterName = value;
                      _filterRooms(); // Filter by name
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Search...',
                      labelStyle: const TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // List of Filtered Rooms
          Expanded(
            child: ListView.builder(
              itemCount: filteredRooms.length,
              itemBuilder: (context, index) {
                final roomItem = filteredRooms[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  color: const Color.fromARGB(255, 34, 34, 34),
                  child: ListTile(
                    title: Text(roomItem.name,
                        style: const TextStyle(color: Colors.white)),
                    subtitle: Text(
                        'Capacity: ${roomItem.capacity}, Type: ${roomItem.type.name}, Building: ${roomItem.building}',
                        style: const TextStyle(color: Colors.white)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Edit Icon
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () => _editRoom(roomItem),
                        ),
                        // Delete Icon
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: () => _deleteRoom(roomItem),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Floating Action Button to Add Rooms
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the AddRoom form
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRoom()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        child: const Icon(Icons.add),
      ),
    );
  }
}
