import 'package:flutter/material.dart';
import 'package:smarn/models/constraint.dart';

class TimeConstraintDetails extends StatelessWidget {
  final TimeConstraint constraint;

  const TimeConstraintDetails({super.key, required this.constraint});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Constraint Details'),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Colors.grey[850],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildDetails(),
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
      details.add(_buildDetailRow('Available Days:', constraint.availableDays.join(', ')));
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
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
