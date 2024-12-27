import 'package:flutter/material.dart';
import 'package:smarn/models/constraint.dart';

class SpaceConstraintDetails extends StatelessWidget {
  final SpaceConstraint constraint;

  const SpaceConstraintDetails({super.key, required this.constraint});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Space Constraint Details'),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildDetails(),
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
    if (constraint.activityType != null) {
      details.add(_buildDetailRow('Activity Type:', constraint.activityType!.name));
    }
    if (constraint.roomId != null) {
      details.add(_buildDetailRow('Room ID:', constraint.roomId!));
    }
    if (constraint.teacherId != null) {
      details.add(_buildDetailRow('Teacher ID:', constraint.teacherId!));
    }
    if (constraint.classId != null) {
      details.add(_buildDetailRow('Class ID:', constraint.classId!));
    }
    if (constraint.subjectId != null) {
      details.add(_buildDetailRow('Subject ID:', constraint.subjectId!));
    }
    if (constraint.requiredRoomType != null) {
      details.add(_buildDetailRow('Required Room Type:', constraint.requiredRoomType!.name));
    }

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
