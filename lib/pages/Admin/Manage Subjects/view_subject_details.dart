import 'package:flutter/material.dart';
import 'package:smarn/models/subject.dart';

class ViewSubjectDetails extends StatelessWidget {
  final Subject subject;

  const ViewSubjectDetails({Key? key, required this.subject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.black ,
      appBar: AppBar(
        title: const Text("Subject Details", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${subject.name}', style: const TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 10),
            Text('Long Name: ${subject.longName ?? 'Not Provided'}', style: const TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 10),
            Text('Description: ${subject.description ?? 'Not Provided'}', style: const TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
