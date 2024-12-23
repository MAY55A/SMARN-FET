import 'package:flutter/material.dart';
import 'package:smarn/models/change_request.dart';
import 'package:smarn/models/change_request_status.dart';
import 'package:smarn/pages/Teacher/Request/edit_request.dart';
import 'package:smarn/pages/Teacher/Request/request_form.dart';
import 'package:smarn/services/auth_service.dart';
import 'package:smarn/services/change_request_service.dart';

class ViewRequests extends StatefulWidget {
  const ViewRequests({super.key});

  @override
  State<ViewRequests> createState() => _ViewRequestsState();
}

class _ViewRequestsState extends State<ViewRequests> {
  final String? teacherId = AuthService().getCurrentUser()?.uid;
  final ChangeRequestService _changeRequestService = ChangeRequestService();
  List<ChangeRequest> _requests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    try {
      setState(() {
        _isLoading = true;
      });
      // Fetch requests by teacher ID
      List<ChangeRequest> requests = await getChangeRequestsByTeacher(teacherId!);
      setState(() {
        _requests = requests;
      });
    } catch (e) {
      _showMessage('Failed to fetch requests: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteRequest(String requestId) async {
    // Show confirmation dialog before deleting
    bool? confirmed = await _showConfirmationDialog();
    if (confirmed == true) {
      try {
        await _changeRequestService.deleteChangeRequest(requestId);
        setState(() {
          _requests.removeWhere((req) => req.id == requestId);
        });
        _showMessage('Request deleted successfully!');
      } catch (e) {
        _showMessage('Failed to delete request: $e');
      }
    }
  }

  Future<bool?> _showConfirmationDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this request?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User canceled
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToEditRequest(ChangeRequest request) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditRequestForm(request: request)),
    ).then((_) {
      _fetchRequests(); // Refresh the list after editing a request
    });
  }

  // Function to return the status icon based on the request status
  Icon _getStatusIcon(ChangeRequestStatus status) {
    switch (status) {
      case ChangeRequestStatus.pending:
        return const Icon(Icons.hourglass_empty, color: Colors.yellow);
      case ChangeRequestStatus.approved:
        return const Icon(Icons.check_circle, color: Colors.green);
      case ChangeRequestStatus.rejected:
        return const Icon(Icons.cancel, color: Colors.red);
      default:
        return const Icon(Icons.help_outline, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Requests"),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _requests.isEmpty
              ? const Center(
                  child: Text(
                    "No requests found.",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: _requests.length,
                  itemBuilder: (context, index) {
                    final request = _requests[index];

                    // Assuming request.status is an enum that you can check
                    ChangeRequestStatus requestStatus = request.status ?? ChangeRequestStatus.pending;

                    return Card(
                      color: Colors.grey[900],
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          request.reason,
                          style: const TextStyle(color: Colors.blue),
                        ),
                        subtitle: Text(
                          request.content,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        leading: _getStatusIcon(requestStatus),  // Display status icon
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _navigateToEditRequest(request),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteRequest(request.id!),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RequestForm()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      backgroundColor: const Color(0xFF2C2C2C),
    );
  }
}
