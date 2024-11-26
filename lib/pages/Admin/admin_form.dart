import 'package:flutter/material.dart';
<<<<<<< HEAD
=======
import 'package:smarn/CRUD_test.dart';
import 'package:smarn/services/admin_service.dart';
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81

class AdminForm extends StatefulWidget {
  const AdminForm({super.key});

  @override
  _AdminFormState createState() => _AdminFormState();
}

class _AdminFormState extends State<AdminForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController =
      TextEditingController(); // Changed from username to email
  final _passwordController = TextEditingController();

  Future<void> _loginAdmin() async {
    if (_formKey.currentState!.validate()) {
<<<<<<< HEAD
      // Simulate login logic
      Navigator.pushReplacementNamed(context, '/admin_dashboard');
=======
      var res = await _adminService.login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );

      if (res["success"]) {
        Navigator.pushReplacementNamed(context, '/admin_dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(res["message"] ?? "Login failed. Unauthorized access.")),
        );
      }
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 9, 17), // Dark background
      appBar: AppBar(
        title: const Text('Admin Form'),
        backgroundColor:
            const Color.fromARGB(255, 129, 77, 139), // Purple theme
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color:
                  const Color.fromARGB(255, 43, 43, 43), // Form container color
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 58, 58, 58).withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
<<<<<<< HEAD
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 400, // Center and limit width for responsiveness
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Admin Login',
=======
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
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
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
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 129, 77, 139), // Button color
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                    child: const Text(
                      'Login',
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // White text for title
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Email Input Field
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(
                          color: Colors.white), // White text inside field
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        labelStyle:
                            TextStyle(color: Colors.white), // White label
                        fillColor: Color.fromARGB(
                            255, 58, 58, 58), // Darker field background
                        filled: true,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        // Validate email format
                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Password Input Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(
                          color: Colors.white), // White text inside field
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        labelStyle:
                            TextStyle(color: Colors.white), // White label
                        fillColor: Color.fromARGB(
                            255, 58, 58, 58), // Darker field background
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
                    // Submit Button
                    ElevatedButton(
                      onPressed: _loginAdmin,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(
                              255, 129, 77, 139), // Purple button color
                        ),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 15.0),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white, // White text on button
                          fontWeight: FontWeight.bold,
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
