import 'package:flutter/material.dart';
import 'package:smarn/pages/widgets/canstants.dart';

class SpaceConstraintsForm extends StatefulWidget {
  const SpaceConstraintsForm({super.key});

  @override
  _SpaceConstraintsFormState createState() => _SpaceConstraintsFormState();
}

class _SpaceConstraintsFormState extends State<SpaceConstraintsForm> {
  final _formKey = GlobalKey<FormState>();
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: const Text("Manage Space Constraints"),
        backgroundColor:  AppColors.appBarColor, // Black AppBar color
      ),
      body: Container(
        color: AppColors.backgroundColor, // Black background color
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                
                  ElevatedButton.icon(
                    onPressed: () {
                      // Logic for managing rooms goes here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Manage Rooms")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 108, 142, 255), // Button background
                      foregroundColor: Colors.white, // Button text color
                      padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.meeting_room),
                    label: const Text(
                      "Manage Rooms ",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Logic for managing buildings goes here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Manage Buildings")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 169, 109, 252), // Button background
                      foregroundColor: Colors.white, // Button text color
                      padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.apartment),
                    label: const Text(
                      "Manage Buildings",
                      style: TextStyle(fontSize: 18),
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
