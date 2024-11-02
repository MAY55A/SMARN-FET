// Form to Edit Personnel Information
import 'package:flutter/material.dart';

class EditPersonnelInformationForm extends StatefulWidget {
  final String personnelName;
  final String personnelId;
  final String email;
  final String phoneNumber;

  const EditPersonnelInformationForm({
    super.key,
    required this.personnelName,
    required this.personnelId,
    required this.email,
    required this.phoneNumber,
  });

  @override
  _EditPersonnelInformationFormState createState() =>
      _EditPersonnelInformationFormState();
}

class _EditPersonnelInformationFormState
    extends State<EditPersonnelInformationForm> {
  late TextEditingController _nameController;
  late TextEditingController _idController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.personnelName);
    _idController = TextEditingController(text: widget.personnelId);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Personnel Information"),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139), // Same color
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.black87, // Dark background color
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(
                    0xFFE0F7FA), // Light blue background for the form
                borderRadius: BorderRadius.circular(20), // Rounded corners
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Form fields to edit personnel info
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Personnel Name",
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Color(0xFF023E8A)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _idController,
                    decoration: const InputDecoration(
                      labelText: "Personnel ID",
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Color(0xFF023E8A)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Color(0xFF023E8A)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Color(0xFF023E8A)),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Save button
                  ElevatedButton(
                    onPressed: () {
                      // Update the information and navigate back
                      setState(() {
                        // Pass the updated data back to the previous page if needed
                        Navigator.pop(context);
                      });
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
                      "Save Changes",
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
}
