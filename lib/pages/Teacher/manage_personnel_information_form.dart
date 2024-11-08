import 'package:flutter/material.dart';
import 'package:smarn/pages/Teacher/edit_personal_information_form.dart';

class ManagePersonnelInformationForm extends StatefulWidget {
  const ManagePersonnelInformationForm({super.key});

  @override
  _ManagePersonnelInformationFormState createState() =>
      _ManagePersonnelInformationFormState();
}

class _ManagePersonnelInformationFormState
    extends State<ManagePersonnelInformationForm> {
  // Variables to hold personnel information
  String personnelName = "Ahmed Ben Saleh";
  String personnelId = "TEA001";
  String email = "ahmed@gmail.com";
  String phoneNumber = "22 345 678";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Personnel Information"),
        backgroundColor: const Color.fromARGB(
            255, 129, 77, 139), // Top bar color from the image
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
                    0xFFE0F7FA), // Light blue background for the card
                borderRadius:
                    BorderRadius.circular(20), // Rounded corners for the card
              ),
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Profile image
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                        'teachers/i3.jpg'), // Replace with your image
                  ),
                  const SizedBox(height: 20),

                  // Name of the personnel
                  Text(
                    personnelName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue, // Name text color
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Personnel ID with icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.badge, color: Colors.blue),
                      const SizedBox(width: 10),
                      Text(
                        personnelId,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Email with icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.email, color: Colors.blue),
                      const SizedBox(width: 10),
                      Text(
                        email,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Phone number with icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.phone, color: Colors.blue),
                      const SizedBox(width: 10),
                      Text(
                        phoneNumber,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Change Personnel Information Button
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to EditPersonnelInformationForm page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditPersonnelInformationForm(
                                  personnelName: personnelName,
                                  personnelId: personnelId,
                                  email: email,
                                  phoneNumber: phoneNumber,
                                )),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32), // Padding for button
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
}
