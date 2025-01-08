import 'package:flutter/material.dart';
import 'package:smarn/models/room.dart';
import 'package:smarn/services/building_service.dart';

class ViewRoom extends StatefulWidget {
  final Room roomItem;

  const ViewRoom({super.key, required this.roomItem});

  @override
  _ViewRoomState createState() => _ViewRoomState();
}

class _ViewRoomState extends State<ViewRoom> {
  String buildingName = "Loading..."; // Placeholder while fetching building name

  @override
  void initState() {
    super.initState();
    _fetchBuildingName();
  }

  Future<void> _fetchBuildingName() async {
    final buildingService = BuildingService();
    final building = await buildingService.getBuildingDetails(widget.roomItem.building);
    setState(() {
      buildingName = building?.name ?? "Unknown Building"; // Update with fetched name
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Room Details'),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          width: 600,
          height: 300,
          child: Card(
            color: const Color.fromARGB(255, 34, 34, 34),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5.0,
            margin: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Room Name: ${widget.roomItem.name}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Description: ${widget.roomItem.description}',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Capacity: ${widget.roomItem.capacity}',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Building: $buildingName', // Display building name
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Room Type: ${widget.roomItem.type.name}',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
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
