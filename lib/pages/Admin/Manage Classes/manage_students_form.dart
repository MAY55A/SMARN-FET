import 'package:flutter/material.dart';
import 'package:smarn/pages/Student/class_dashboard.dart';
import 'package:smarn/pages/widgets/canstants.dart'; // Import the new student dashboard

class ManageStudentsForm extends StatefulWidget {
  const ManageStudentsForm({super.key});

  @override
  _ManageStudentsFormState createState() => _ManageStudentsFormState();
}

class _ManageStudentsFormState extends State<ManageStudentsForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Students"),
        backgroundColor: AppColors.appBarColor,
      ),
      body: Container(
        color: AppColors.backgroundColor,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
        ),
      ),
    ));
  }
}
