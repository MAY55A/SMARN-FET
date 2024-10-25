import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smarn/pages/home.dart'; // Ensure you have this file
import 'package:smarn/firebase_options.dart';

//Firebase configuration
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
