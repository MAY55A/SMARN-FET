import 'package:flutter/material.dart';
import 'package:smarn/models/constraint.dart';

class SpaceConstraintDetails extends StatelessWidget {
  final SpaceConstraint constraint;

  const SpaceConstraintDetails({super.key, required this.constraint});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Space Constraint Details'),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        elevation: 0, // Remove app bar shadow for cleaner look
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
                        'Space Constraint Details',
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

    // Add Active field
    details.add(_buildDetailRow('Active:', constraint.isActive ? 'Yes' : 'No'));

    return details;
  }

  // Builds a row for displaying each detail
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Slightly more space between rows
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15, // Slightly larger text size for readability
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15, // Matching font size for consistency
              ),
              overflow: TextOverflow.ellipsis, // Handle long text gracefully
            ),
          ),
        ],
      ),
    );
  }
}
