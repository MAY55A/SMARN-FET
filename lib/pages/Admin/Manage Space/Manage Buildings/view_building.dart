import 'package:flutter/material.dart';
import 'package:smarn/models/building.dart';
import 'package:smarn/models/room.dart';
import 'package:smarn/services/room_service.dart'; // Import RoomService
import 'package:smarn/pages/Admin/Manage Space/Manage Rooms/view_room.dart'; // Import ViewRoom page

class ViewBuilding extends StatefulWidget {
  final Building building;

  const ViewBuilding({super.key, required this.building});

  @override
  State<ViewBuilding> createState() => _ViewBuildingState();
}

class _ViewBuildingState extends State<ViewBuilding> {
  final RoomService _roomService = RoomService();
  List<Room> rooms = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRooms();
  }

  Future<void> _fetchRooms() async {
    setState(() {
      isLoading = true;
    });

    try {
      rooms = await _roomService.getRoomsByBuilding(widget.building.id!);
    } catch (e) {
      print('Error fetching rooms: $e');
      rooms = [];
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.building.name),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Card(
                    color: const Color.fromARGB(255, 34, 34, 34),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Building Info Section
                          Text(
                            'Building Information',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Description: ${widget.building.description}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Long Name: ${widget.building.longName}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Rooms List Section
                          Text(
                            'Rooms in this building:',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // List of Rooms or No Rooms Found Message
                          rooms.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No rooms found in this building.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                )
                              : Column(
                                  children: rooms.map((room) {
                                    return GestureDetector(
                                      onTap: () {
                                        // Navigate to the ViewRoom page
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ViewRoom(roomItem: room),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        color: const Color.fromARGB(255, 50, 50, 50),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Room Name: ${room.name}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Capacity: ${room.capacity}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
