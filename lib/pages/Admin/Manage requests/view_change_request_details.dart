import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:smarn/models/change_request.dart';
import 'package:smarn/models/change_request_status.dart';
import 'package:smarn/pages/widgets/canstants.dart';
import 'package:smarn/services/change_request_service.dart';
import 'package:smarn/models/teacher.dart';
import 'package:smarn/services/teacher_service.dart';

class ViewChangeRequestDetails extends StatefulWidget {
  final ChangeRequest request;

  const ViewChangeRequestDetails({super.key, required this.request});

  @override
  _ViewChangeRequestDetailsState createState() =>
      _ViewChangeRequestDetailsState();
}

class _ViewChangeRequestDetailsState extends State<ViewChangeRequestDetails> {
  String? teacherName;

  @override
  void initState() {
    super.initState();
    fetchTeacherName();
  }

  /// Fetch the teacher's name based on their ID.
  void fetchTeacherName() async {
    if (widget.request.teacher != null) {
      try {
        final teacherService = TeacherService();
        final teacher = await teacherService.getTeacher(widget.request.teacher);
        if (teacher != null) {
          setState(() {
            teacherName =
                teacher.name; // Assuming Teacher model has a `name` field.
          });
        }
      } catch (e) {
        print("Error fetching teacher name: $e");
      }
    }
  }

  /// Formats the date to a readable format.
  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final DateTime parsedDate = DateTime.parse(dateString);
      return DateFormat('MMMM dd, yyyy - hh:mm a').format(parsedDate);
    } catch (e) {
      return 'Invalid date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Request Details"),
        backgroundColor: AppColors.appBarColor,
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show teacher ID and name
            if (widget.request.teacher != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Teacher ID: ${widget.request.teacher}',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  if (teacherName != null)
                    Text(
                      'Teacher Name: $teacherName',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                ],
              ),
            const SizedBox(height: 8),

            // Show newTimeSlot only if it is not null
            if (widget.request.newTimeSlot != null)
              Text(
                'New Time Slot: ${widget.request.newTimeSlot}',
                style: const TextStyle(color: Colors.white),
              ),

            // Show newRoom only if it is not null
            if (widget.request.newRoom != null)
              Text(
                'New Room: ${widget.request.newRoom}',
                style: const TextStyle(color: Colors.white),
              ),

            // Show activity only if it is not null
            if (widget.request.activity != null)
              Text(
                'Activity: ${widget.request.activity}',
                style: const TextStyle(color: Colors.white),
              ),

            const SizedBox(height: 8),

            // Show reason only if it is not null
            if (widget.request.reason != null)
              Text(
                'Reason: ${widget.request.reason}',
                style: const TextStyle(color: Colors.white),
              ),

            // Show content only if it is not null
            if (widget.request.content != null)
              Text(
                'Content: ${widget.request.content}',
                style: const TextStyle(color: Colors.white),
              ),

            // Show submissionDate only if it is not null
            if (widget.request.submissionDate != null)
              Text(
                'Date Submitted: ${formatDate(widget.request.submissionDate)}',
                style: const TextStyle(color: Colors.white),
              ),

            const SizedBox(height: 20),

            // Show status only if it is not null
            if (widget.request.status != null)
              Text(
                'Status: ${widget.request.status?.name}',
                style: const TextStyle(color: Colors.white),
              ),

            const SizedBox(height: 20),

            // Approve and Reject Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Approve request
                    final updatedRequest = ChangeRequest(
                      id: widget.request.id,
                      newTimeSlot: widget.request.newTimeSlot,
                      newRoom: widget.request.newRoom,
                      activity: widget.request.activity,
                      reason: widget.request.reason,
                      content: widget.request.content,
                      teacher: widget.request.teacher,
                      submissionDate: widget.request.submissionDate,
                      status: ChangeRequestStatus.approved,
                    );

                    await ChangeRequestService().updateChangeRequest(
                        widget.request.id!, updatedRequest);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Approve'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Reject request
                    final updatedRequest = ChangeRequest(
                      id: widget.request.id,
                      newTimeSlot: widget.request.newTimeSlot,
                      newRoom: widget.request.newRoom,
                      activity: widget.request.activity,
                      reason: widget.request.reason,
                      content: widget.request.content,
                      teacher: widget.request.teacher,
                      submissionDate: widget.request.submissionDate,
                      status: ChangeRequestStatus.rejected,
                    );

                    await ChangeRequestService().updateChangeRequest(
                        widget.request.id!, updatedRequest);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Reject'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
