import 'package:flutter/material.dart';
import 'package:smarn/pages/Home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SMARN',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Choose one home screen to display
      home: const HomePage(),
    );
  }
}
