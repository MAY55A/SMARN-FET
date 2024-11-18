import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smarn/models/teacher.dart';
import 'package:smarn/services/teacher_service.dart';
import 'edit_personal_information_form.dart';

class ManagePersonnelInformationForm extends StatefulWidget {
  const ManagePersonnelInformationForm({super.key});

  @override
  State<ManagePersonnelInformationForm> createState() =>
      _ManagePersonnelInformationFormState();
}

class _ManagePersonnelInformationFormState
    extends State<ManagePersonnelInformationForm> {
  String personnelName = "";
  String personnelId = "";
  String email = "";
  String phoneNumber = "";
  bool loading = true;

  // Search bar query state
  String searchQuery = "";

  // Teacher data
  Teacher? currentTeacher;

  // Fetch the personnel information (authenticated user data)
  Future<void> _fetchPersonnelInfo() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        Teacher? teacher = await TeacherService().fetchTeacherData();
        if (teacher != null) {
          setState(() {
            currentTeacher = teacher;
            personnelName = teacher.name ?? currentUser.displayName ?? "Unknown";
            email = currentUser.email ?? "No email provided";
            phoneNumber = teacher.phone ?? currentUser.phoneNumber ?? "No phone number provided";
            personnelId = teacher.id ?? currentUser.uid;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching user information: $e")),
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPersonnelInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Personnel Information"),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.black87,
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F7FA),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // Search Bar
                      TextField(
                        onChanged: (query) {
                          setState(() {
                            searchQuery = query;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Search Teacher',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Display teacher info
                      Text(
                        personnelName.isEmpty ? "Loading..." : personnelName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildInfoRow(Icons.badge, personnelId),
                      const SizedBox(height: 10),
                      _buildInfoRow(Icons.email, email),
                      const SizedBox(height: 10),
                      _buildInfoRow(Icons.phone, phoneNumber),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPersonnelInformationForm(
                                personnelName: personnelName,
                                personnelId: personnelId,
                                email: email,
                                phoneNumber: phoneNumber,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 32),
                        ),
                        child: const Text(
                          "Change Personnel Information",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // Info Row Builder
  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 10),
        Text(
          text.isEmpty ? "Loading..." : text,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ],
    );
  }
}
