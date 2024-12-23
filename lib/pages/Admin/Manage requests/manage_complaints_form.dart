import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:smarn/models/change_request_status.dart';
import 'package:smarn/pages/Admin/Manage%20requests/view_change_request_details.dart';
import 'package:smarn/pages/widgets/canstants.dart';
import 'package:smarn/models/change_request.dart';
import 'package:smarn/services/change_request_service.dart';
import 'package:smarn/services/teacher_service.dart';

class ManageComplaintsForm extends StatefulWidget {
  const ManageComplaintsForm({super.key});

  @override
  _ManageComplaintsFormState createState() => _ManageComplaintsFormState();
}

class _ManageComplaintsFormState extends State<ManageComplaintsForm> {
  late Future<List<ChangeRequest>> _changeRequests;

  @override
  void initState() {
    super.initState();
    _changeRequests = fetchChangeRequestsWithTeacherNames();
  }

  /// Fetch change requests and attach teacher names based on their IDs.
  Future<List<ChangeRequest>> fetchChangeRequestsWithTeacherNames() async {
    final changeRequests = await ChangeRequestService().getAllChangeRequests();
    final teacherService = TeacherService();

    for (var request in changeRequests) {
      if (request.teacher != null) {
        try {
          final teacher = await teacherService.getTeacher(request.teacher!);
          request.teacher = teacher?.name ?? request.teacher; // Replace ID with name if available.
        } catch (e) {
          print("Error fetching teacher name for ID ${request.teacher}: $e");
        }
      }
    }

    return changeRequests;
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

  /// Get the status color based on the status.
  Color getStatusColor(ChangeRequestStatus? status) {
    switch (status) {
      case ChangeRequestStatus.approved:
        return Colors.green;
      case ChangeRequestStatus.rejected:
        return Colors.red;
      case ChangeRequestStatus.pending:
      default:
        return Colors.yellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Requests"),
        backgroundColor: AppColors.appBarColor,
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<List<ChangeRequest>>(
              future: _changeRequests,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text(
                    'No change requests available.',
                    style: TextStyle(color: Colors.white),
                  );
                }

                final changeRequests = snapshot.data!;

                return ListView.builder(
                  itemCount: changeRequests.length,
                  itemBuilder: (context, index) {
                    final request = changeRequests[index];
                    return Card(
                      color: AppColors.formColor, // Set the card's background color to blue.
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(
                          request.teacher ?? 'Unknown Teacher',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              'Reason: ${request.reason ?? 'N/A'}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Date: ${formatDate(request.submissionDate)}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  'Status: ${request.status?.name ?? 'N/A'}',
                                  style: TextStyle(
                                    color: getStatusColor(request.status),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  request.status == ChangeRequestStatus.approved
                                      ? Icons.check_circle
                                      : request.status == ChangeRequestStatus.rejected
                                          ? Icons.cancel
                                          : Icons.pending,
                                  color: getStatusColor(request.status),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ViewChangeRequestDetails(request: request),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          child: const Text(
                            'View Details',
                            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
