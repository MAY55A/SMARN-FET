import 'package:flutter/material.dart';
import 'package:smarn/pages/widgets/canstants.dart';

class TimeConstraintsForm extends StatefulWidget {
  const TimeConstraintsForm({super.key});

  @override
  _TimeConstraintsFormState createState() => _TimeConstraintsFormState();
}

class _TimeConstraintsFormState extends State<TimeConstraintsForm> {
 
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Time Constraints"),
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
