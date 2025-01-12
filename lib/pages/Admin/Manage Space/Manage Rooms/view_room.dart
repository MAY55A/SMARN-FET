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
      backgroundColor: Colors.black, // Dark background
      appBar: AppBar(
        title: const Text('Room Details'),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 600, // Set a max width for the card
            ),
            child: Card(
              color: Colors.grey[850], // Card background color
              elevation: 10, // Shadow effect
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0), // Rounded corners
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0), // Padding inside the card
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Minimum space needed
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        widget.roomItem.name ?? 'No name available',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20, // Font size for the name
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(
                      color: Colors.white54,
                      thickness: 1,
                      height: 16,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Description: ${widget.roomItem.description ?? 'Not Provided'}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Capacity: ${widget.roomItem.capacity ?? 'Not Available'}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Building: $buildingName",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Room Type: ${widget.roomItem.type?.name ?? 'Not Provided'}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
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
