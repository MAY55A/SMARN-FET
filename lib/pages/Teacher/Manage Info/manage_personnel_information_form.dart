import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smarn/models/teacher.dart';
import 'package:smarn/pages/Teacher/Account%20Settings/account_settings.dart';
import 'package:smarn/services/auth_service.dart';
import 'package:smarn/services/teacher_service.dart';

class ManagePersonnelInformationForm extends StatefulWidget {
  const ManagePersonnelInformationForm({super.key});

  @override
  State<ManagePersonnelInformationForm> createState() =>
      _ManagePersonnelInformationFormState();
}

class _ManagePersonnelInformationFormState
    extends State<ManagePersonnelInformationForm> {
  User? currentUser = AuthService().getCurrentUser();
  String personnelName = "";
  String personnelId = "";
  String email = "";
  String? phoneNumber = "";
  bool loading = true;

  // Teacher data
  Teacher? currentTeacher;

  // Fetch the personnel information (authenticated user data)
  Future<void> _fetchPersonnelInfo() async {
    try {
      if (currentUser != null) {
        Teacher? teacher = await TeacherService().fetchTeacherData();
        if (teacher != null) {
          setState(() {
            currentTeacher = teacher;
            personnelName = teacher.name;
            email = teacher.email ?? currentUser!.email!;
            phoneNumber = teacher.phone;
            personnelId = teacher.id!;
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
      backgroundColor: Colors.black,
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
                                  currentTeacher!
                                      .picture, // Assuming picture stores a file name like 'default.jpg'
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
                        _buildInfoRow(Icons.perm_identity, "Account ID :",
                            currentUser!.uid),
                        const SizedBox(height: 10),
                        _buildInfoRow(Icons.badge, "Teacher ID :", personnelId),
                        const SizedBox(height: 10),
                        _buildInfoRow(Icons.email, "Email :", email),
                        const SizedBox(height: 10),
                        _buildInfoRow(Icons.phone, "Phone :", phoneNumber!),
                        const SizedBox(height: 10),
                        _buildInfoRow(
                            Icons.access_time_filled,
                            "Target Hours :",
                            currentTeacher!.nbHours.toString()),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AccountSettingsPage()
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
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 10),
        Text(label,
            style: const TextStyle(
                fontSize: 15,
                color: Color.fromARGB(221, 12, 59, 104),
                fontWeight: FontWeight.bold)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value.isNotEmpty ? value : "Loading...",
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
