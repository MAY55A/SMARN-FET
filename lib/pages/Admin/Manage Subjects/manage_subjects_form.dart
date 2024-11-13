import 'package:flutter/material.dart';
import 'package:smarn/pages/widgets/canstants.dart';

class ManageSubjectsForm extends StatefulWidget {
  const ManageSubjectsForm({super.key});

  @override
  _ManageSubjectsFormState createState() => _ManageSubjectsFormState();
}

class _ManageSubjectsFormState extends State<ManageSubjectsForm> {


 
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Subjects"),
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


