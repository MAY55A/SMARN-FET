import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:smarn/models/change_request.dart';
import 'package:smarn/models/change_request_status.dart';
import 'package:smarn/services/change_request_service.dart';
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
            teacherName = teacher.name;
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

  /// Show an alert dialog for confirmation before approval or rejection.
  Future<void> showConfirmationDialog(String action) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            action == 'approve' ? 'Approve Request?' : 'Reject Request?',
            style: const TextStyle(color: Colors.white),
          ),
          content: Text(
            action == 'approve'
                ? 'Are you sure you want to approve this change request?'
                : 'Are you sure you want to reject this change request?',
            style: const TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
            ),
            TextButton(
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                String message = '';
                // Handle approval or rejection based on the action
                if (action == 'approve') {
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

                  await ChangeRequestService()
                      .updateChangeRequest(widget.request.id!, updatedRequest);
                  setState(() {
                    widget.request.status = ChangeRequestStatus.approved;
                  });
                  message = 'Request approved successfully!';
                } else if (action == 'reject') {
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

                  await ChangeRequestService()
                      .updateChangeRequest(widget.request.id!, updatedRequest);
                  setState(() {
                    widget.request.status = ChangeRequestStatus.rejected;
                  });
                  message = 'Request rejected successfully!';
                }

                Navigator.pop(context); // Close the confirmation dialog
                Navigator.pop(context); // Close the details screen

                // Show the confirmation message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  /// Get the color and symbol based on the request's status.
  Color getStatusColor(ChangeRequestStatus status) {
    switch (status) {
      case ChangeRequestStatus.approved:
        return Colors.green;
      case ChangeRequestStatus.rejected:
        return Colors.red;
      default:
        return Colors.yellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      appBar: AppBar(
        title: const Text("Request Details"),
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
                        'Change Request Details',
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
                    if (widget.request.teacher != null)
                      Text(
                        'Teacher ID: ${widget.request.teacher}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    const SizedBox(height: 12),
                    if (teacherName != null)
                      Text(
                        'Teacher Name: $teacherName',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    const SizedBox(height: 12),
                    if (widget.request.newTimeSlot != null)
                      Text(
                        'New Time Slot: ${widget.request.newTimeSlot}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    const SizedBox(height: 12),
                    if (widget.request.newRoom != null)
                      Text(
                        'New Room: ${widget.request.newRoom}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    const SizedBox(height: 12),
                    if (widget.request.activity != null)
                      Text(
                        'Activity: ${widget.request.activity}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    const SizedBox(height: 12),
                    if (widget.request.reason != null)
                      Text(
                        'Reason: ${widget.request.reason}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    const SizedBox(height: 12),
                    if (widget.request.content != null)
                      Text(
                        'Content: ${widget.request.content}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    const SizedBox(height: 12),
                    if (widget.request.submissionDate != null)
                      Text(
                        'Date Submitted: ${formatDate(widget.request.submissionDate)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    const SizedBox(height: 12),
                    if (widget.request.status != null)
                      Row(
                        children: [
                          Icon(
                            widget.request.status == ChangeRequestStatus.approved
                                ? Icons.check_circle
                                : widget.request.status == ChangeRequestStatus.rejected
                                    ? Icons.cancel
                                    : Icons.pending,
                            color: getStatusColor(widget.request.status!),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Status: ${widget.request.status?.name ?? 'N/A'}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    if (widget.request.status == ChangeRequestStatus.pending)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              showConfirmationDialog('approve');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Text('Approve'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showConfirmationDialog('reject');
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
            ),
          ),
        ),
      ),
    );
  }
}
