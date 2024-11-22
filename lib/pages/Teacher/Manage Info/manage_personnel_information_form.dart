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
            personnelName =
                teacher.name ?? currentUser.displayName ?? "Unknown";
            email = currentUser.email ?? "No email provided";
            phoneNumber = teacher.phone ??
                currentUser.phoneNumber ?? "No phone number provided";
            personnelId = teacher.id ?? currentUser.uid;
          });
        } else {
          throw Exception("Teacher data not found.");
        }
      } else {
        throw Exception("User not authenticated.");
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
        backgroundColor: Colors.blue,
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // Display current image from assets
                        currentTeacher?.picture != null
                            ? CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage(
                                                          '${currentTeacher!.picture}', // Assuming picture stores a file name like 'default.jpg'
                                ),
                              )
                            : const Icon(
                                Icons.account_circle,
                                size: 100,
                                color: Colors.blue,
                              ),
                        const SizedBox(height: 20),
                        // Display teacher info
                        Text(
                          personnelName.isNotEmpty
                              ? personnelName
                              : "Loading...",
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
                                builder: (context) =>
                                    EditPersonnelInformationForm(
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
        Expanded(
          child: Text(
            text.isNotEmpty ? text : "Loading...",
            style: const TextStyle(fontSize: 16, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
