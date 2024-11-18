import 'package:flutter/material.dart';
import 'package:smarn/pages/widgets/canstants.dart';
import 'package:smarn/services/admin_service.dart';

class AdminForm extends StatefulWidget {
  const AdminForm({super.key});

  @override
  _AdminFormState createState() => _AdminFormState();
}

class _AdminFormState extends State<AdminForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final AdminService _adminService = AdminService();

  Future<void> _loginAdmin() async {
    if (_formKey.currentState!.validate()) {
      var res = await _adminService.login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );
      if (res["success"]) {
        Navigator.pushReplacementNamed(context, '/admin_dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res["message"])),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 9, 17),
      appBar: AppBar(
        title: const Text('Admin Form'),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.formColor, // Light gray background for the form
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Text color for the title
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _usernameController,
                    style: const TextStyle(color: Colors.white), // Text color inside field
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white), // Label color
                      fillColor: Color.fromARGB(255, 58, 58, 58), // Background color of the text field
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white), // Text color inside field
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white), // Label color
                      fillColor: Color.fromARGB(255, 58, 58, 58), // Background color of the text field
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _loginAdmin,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(AppColors.appBarColor), // Pink background color
                      foregroundColor: MaterialStateProperty.all(Colors.black), // Black text color inside button
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)), // Text color inside button
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
