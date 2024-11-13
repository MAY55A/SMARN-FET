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
        backgroundColor: AppColors.appBarColor, // Black AppBar color
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
                  // Elevated card-like button for Manage Rooms
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Manage Rooms")),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 108, 142, 255),
                            Color.fromARGB(255, 129, 176, 255),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(2, 4),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 25),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.meeting_room, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            "Manage Rooms",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Elevated card-like button for Manage Buildings
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Manage Buildings")),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 169, 109, 252),
                            Color.fromARGB(255, 191, 144, 255),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(2, 4),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 25),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.apartment, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            "Manage Buildings",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
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
