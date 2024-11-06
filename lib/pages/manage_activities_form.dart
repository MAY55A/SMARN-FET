import 'package:flutter/material.dart';

class ManageActivitiesForm extends StatelessWidget {
  const ManageActivitiesForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Activities'),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139), // AppBar color
      ),
      body: Center(
        child: const Text(
          'Here you can manage activities.',
          style: TextStyle(fontSize: 20), // Style for the text
        ),
      ),
    );
  }
}
