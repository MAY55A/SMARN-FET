import 'package:flutter/material.dart';
import 'package:smarn/models/building.dart';
import 'package:smarn/models/room.dart';
import 'package:smarn/services/room_service.dart'; // Import RoomService

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

    rooms = await _roomService.getRoomsByBuilding(widget.building.id!);

    setState(() {
      isLoading = false;
    });
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
                child: Column(
                  children: [
                    // Building Info Section
                    Card(
                      color: const Color.fromARGB(255, 34, 34, 34),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description: ${widget.building.description}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Long Name: ${widget.building.longName}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: rooms.length,
                      itemBuilder: (context, index) {
                        final room = rooms[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          color: const Color.fromARGB(255, 34, 34, 34),
                          child: ListTile(
                            title: Text(room.name, style: const TextStyle(color: Colors.white)),
                            subtitle: Text(
                              '${room.capacity} people - ${room.type.name}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
