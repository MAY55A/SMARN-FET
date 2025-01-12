import 'package:flutter/material.dart';
import 'package:smarn/models/constraint.dart';

class TimeConstraintDetails extends StatelessWidget {
  final TimeConstraint constraint;

  const TimeConstraintDetails({super.key, required this.constraint});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Time Constraint Details'),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 400, // Set a max width for the card
            ),
            child: Card(
              color: Colors.grey[850], // Card color
              elevation: 10,
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
                        'Time Constraint Details',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20, // Font size
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
                    ..._buildDetails(),
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

  // Builds a list of detail rows, showing only non-null fields
  List<Widget> _buildDetails() {
    List<Widget> details = [];

    // Check each field and add it if non-null
    if (constraint.id != null) {
      details.add(_buildDetailRow('ID:', constraint.id!));
    }
    if (constraint.type != null) {
      details.add(_buildDetailRow('Type:', constraint.type.toString().split('.').last));
    }
    if (constraint.startTime != null) {
      details.add(_buildDetailRow('Start Time:', constraint.startTime!));
    }
    if (constraint.endTime != null) {
      details.add(_buildDetailRow('End Time:', constraint.endTime!));
    }
    if (constraint.availableDays.isNotEmpty) {
      // Map Workday enums to plain day names
      final availableDaysNames = constraint.availableDays.map((day) {
        return day.toString().split('.').last.capitalize();
      }).join(', ');
      details.add(_buildDetailRow('Available Days:', availableDaysNames));
    }
    if (constraint.teacherId != null) {
      details.add(_buildDetailRow('Teacher ID:', constraint.teacherId!));
    }
    if (constraint.classId != null) {
      details.add(_buildDetailRow('Class ID:', constraint.classId!));
    }
    if (constraint.roomId != null) {
      details.add(_buildDetailRow('Room ID:', constraint.roomId!));
    }
    // Add active status field
    details.add(_buildDetailRow('Active:', constraint.isActive ? 'Yes' : 'No'));

    return details;
  }

  // Builds a row for displaying each detail
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Add a string extension to capitalize the first letter
extension StringExtension on String {
  String capitalize() {
    return this.isNotEmpty ? this[0].toUpperCase() + substring(1).toLowerCase() : '';
  }
}
