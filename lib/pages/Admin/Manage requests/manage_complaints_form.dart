import 'package:flutter/material.dart';
import 'package:smarn/pages/widgets/canstants.dart';

class ManageComplaintsForm extends StatefulWidget {
  const ManageComplaintsForm({super.key});

  @override
  _ManageComplaintsFormState createState() => _ManageComplaintsFormState();
}

class _ManageComplaintsFormState extends State<ManageComplaintsForm> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
    title: const Text("Manage Requests"),
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
