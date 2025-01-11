import 'package:flutter/material.dart';
import 'package:smarn/pages/Admin/admin_dashboard.dart';
import 'package:smarn/services/admin_service.dart';
import 'package:smarn/pages/widgets/canstants.dart'; // Ensure this is available for your color palette

class AdminForm extends StatefulWidget {
  const AdminForm({super.key});

  @override
  _AdminFormState createState() => _AdminFormState();
}

class _AdminFormState extends State<AdminForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AdminService _adminService = AdminService();

  bool _isPasswordVisible = false; // Track password visibility

  Future<void> _loginAdmin() async {
    if (_formKey.currentState!.validate()) {
      var res = await _adminService.login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );

      if (res["success"]) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminDashboard()),
          );      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(res["message"] ?? "Login failed. Unauthorized access."),
          ),
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
                  color: const Color.fromARGB(255, 43, 43, 43).withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 400, // Match the width of the EducatorForm
              ),
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
                        color: Colors.white, // Text color white for title
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _usernameController,
                      style: const TextStyle(
                          color: Colors.white), // Text color inside field
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        labelStyle:
                            TextStyle(color: Colors.white), // Label color white
                        fillColor: Color.fromARGB(255, 58, 58,
                            58), // Background color of the text field
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
                      obscureText: !_isPasswordVisible, // Toggle visibility
                      style: const TextStyle(
                          color: Colors.white), // Text color inside field
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Password',
                        labelStyle: const TextStyle(
                            color: Colors.white), // Label color white
                        fillColor: const Color.fromARGB(255, 58, 58,
                            58), // Background color of the text field
                        filled: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white, // Icon color white
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
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
                        backgroundColor: MaterialStateProperty.all(
                            AppColors.appBarColor), // Button color pink
                        foregroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(
                                255, 255, 255, 255)), // Button text color black
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Color.fromARGB(
                              255, 255, 255, 255), // Button text color white
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
