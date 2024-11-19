import 'package:flutter/material.dart';
import 'package:smarn/pages/widgets/canstants.dart';

class ManageTimetablesForm extends StatefulWidget {
  const ManageTimetablesForm({super.key});

  @override
  _ManageTimetablesFormState createState() => _ManageTimetablesFormState();
}

class _ManageTimetablesFormState extends State<ManageTimetablesForm> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
   appBar: AppBar(
     title: const Text("Manage Tables"),
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
