import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smarn/models/change_request_status.dart';
import 'package:smarn/pages/Admin/Manage%20requests/view_request_details.dart';
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

  Future<List<ChangeRequest>> fetchChangeRequestsWithTeacherNames() async {
    final changeRequests = await ChangeRequestService().getAllChangeRequests();
    final teacherService = TeacherService();

    for (var request in changeRequests) {
      if (request.teacher != null) {
        try {
          final teacher = await teacherService.getTeacher(request.teacher!);
          request.teacher = teacher?.name ?? request.teacher;
        } catch (e) {
          print("Error fetching teacher name for ID ${request.teacher}: $e");
        }
      }
    }

    return changeRequests;
  }

  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final DateTime parsedDate = DateTime.parse(dateString);
      return DateFormat('MMMM dd, yyyy - hh:mm a').format(parsedDate);
    } catch (e) {
      return 'Invalid date';
    }
  }

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

  // Delete change request method
  Future<void> deleteChangeRequest(String requestId) async {
    final result = await ChangeRequestService().deleteChangeRequest(requestId);
    if (result['success'] == true) {
      setState(() {
        _changeRequests =
            fetchChangeRequestsWithTeacherNames(); // Refresh the list
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request deleted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${result['message']}')),
      );
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
                      color: AppColors.formColor,
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
                                      : request.status ==
                                              ChangeRequestStatus.rejected
                                          ? Icons.cancel
                                          : Icons.pending,
                                  color: getStatusColor(request.status),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ViewChangeRequestDetails(
                                            request: request),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.appBarColor,
                              ),
                              child: const Text(
                                'View Details',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                // Confirmation dialog before deleting
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Confirm Deletion'),
                                    content: const Text(
                                        'Are you sure you want to delete this request?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          deleteChangeRequest(request.id!);
                                        },
                                        style: const ButtonStyle(
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                                    Colors.red),
                                            foregroundColor:
                                                WidgetStatePropertyAll(
                                                    Colors.white)),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
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
