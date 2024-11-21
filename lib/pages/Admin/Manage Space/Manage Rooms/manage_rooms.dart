import 'package:flutter/material.dart';
import 'package:smarn/models/room.dart';
import 'package:smarn/services/room_service.dart'; // Import the RoomService
import 'add_room.dart'; // Import the AddRoom screen
import 'edit_room.dart'; // Import the EditRoom screen

class ManageRooms extends StatefulWidget {
  const ManageRooms({super.key});

  @override
  State<ManageRooms> createState() => _ManageRoomsState();
}

class _ManageRoomsState extends State<ManageRooms> {
  final RoomService _roomService = RoomService();
  List<Room> rooms = [];
  List<Room> filteredRooms = [];
  String filterName = '';

  @override
  void initState() {
    super.initState();
    _fetchRooms(); // Fetch rooms dynamically on initialization
  }

  // Fetch rooms from the service
  Future<void> _fetchRooms() async {
    try {
      final fetchedRooms = await _roomService.getAllRooms();
      setState(() {
        rooms = fetchedRooms;
        filteredRooms = rooms;
      });
    } catch (e) {
      _showErrorAlert('Failed to fetch rooms. Please try again.');
    }
  }

  // Filter rooms based on the search input
  void _filterRooms() {
    setState(() {
      filteredRooms = rooms
          .where((roomItem) => roomItem.name.toLowerCase().contains(filterName.toLowerCase()))
          .toList();
    });
  }

  // Handle editing a room
  Future<void> _editRoom(Room roomItem) async {
    final updatedRoom = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditRoom(roomItem: roomItem),
      ),
    );

    if (updatedRoom != null) {
      try {
        final result = await _roomService.updateRoom(updatedRoom.id, updatedRoom);
        if (result['success']) {
          setState(() {
            int index = rooms.indexWhere((r) => r.id == updatedRoom.id);
            if (index != -1) {
              rooms[index] = updatedRoom;
            }
            _filterRooms();
          });
        } else {
          _showErrorAlert('Failed to update room: ${result['message']}');
        }
      } catch (e) {
        _showErrorAlert('An error occurred while updating the room.');
      }
    }
  }

  // Handle deleting a room with confirmation
  void _deleteRoom(Room roomItem) async {
    final confirm = await _showConfirmationAlert('Delete Room', 'Are you sure you want to delete ${roomItem.name}?');
    if (confirm) {
      try {
        final result = await _roomService.deleteRoom(roomItem.id!);
        if (result['success']) {
          setState(() {
            rooms.removeWhere((room) => room.id == roomItem.id);
            _filterRooms();
          });
        } else {
          _showErrorAlert('Failed to delete room: ${result['message']}');
        }
      } catch (e) {
        _showErrorAlert('An error occurred while deleting the room.');
      }
    }
  }

  // Show error alert
  void _showErrorAlert(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Show confirmation alert
  Future<bool> _showConfirmationAlert(String title, String message) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    return result ?? false;
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
          // Search bar for filtering rooms
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterName = value;
                _filterRooms();
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
          // List of filtered rooms
          Expanded(
            child: filteredRooms.isEmpty
                ? const Center(
                    child: Text(
                      'No rooms found',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredRooms.length,
                    itemBuilder: (context, index) {
                      final roomItem = filteredRooms[index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        color: const Color.fromARGB(255, 34, 34, 34),
                        child: ListTile(
                          title: Text(roomItem.name, style: const TextStyle(color: Colors.white)),
                          subtitle: Text(
                            'Capacity: ${roomItem.capacity}, Type: ${roomItem.type.name}, Building: ${roomItem.building}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Edit icon
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.white),
                                onPressed: () => _editRoom(roomItem),
                              ),
                              // Delete icon
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newRoom = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRoom()),
          );
          if (newRoom != null) {
            try {
              final result = await _roomService.addRoom(newRoom);
              if (result['success']) {
                setState(() {
                  rooms.add(Room.fromMap(result['data']));
                  _filterRooms();
                });
              } else {
                _showErrorAlert('Failed to add room: ${result['message']}');
              }
            } catch (e) {
              _showErrorAlert('An error occurred while adding the room.');
            }
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
    );
  }
}
