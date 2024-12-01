import 'package:flutter/material.dart';
import 'package:smarn/models/change_request.dart';
import 'package:smarn/services/auth_service.dart';
import 'package:smarn/services/change_request_service.dart';
import 'request_form.dart';

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
      List<ChangeRequest> requests =
          await getChangeRequestsByTeacher(teacherId!);
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

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToAddRequest() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RequestForm()),
    ).then((_) {
      _fetchRequests(); // Refresh the list after adding a request
    });
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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                // Navigate to edit form (Add the implementation if needed)
                              },
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
        onPressed: _navigateToAddRequest,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      backgroundColor: const Color(0xFF2C2C2C),
    );
  }
}
