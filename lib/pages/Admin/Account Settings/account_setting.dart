import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smarn/services/auth_service.dart';
import 'package:smarn/pages/widgets/canstants.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final AuthService _authService = AuthService();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _newPasswordConfirmController = TextEditingController();
  bool _isPasswordVisible = false; // Toggle visibility for all passwords

  // Function to update email and password after verifying current password
  Future<void> _updateCredentials() async {
    final currentPassword = _currentPasswordController.text.trim();
    if (currentPassword.isEmpty) {
      _showError('Please enter your current password.');
      return;
    }

    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _newPasswordConfirmController.text.trim();

    if (newPassword == currentPassword) {
      _showError('You need to enter a new different password.');
      return;
    }
    if (newPassword != confirmPassword) {
      _showError('Passwords do not match.');
      return;
    }

    if (newPassword.length < 6) {
      _showError('Password should be at least 6 characters.');
      return;
    }

    try {
      // Update credentials using the AuthService
      final message = await _authService.updateUserCredentials(
        currentPassword: currentPassword,
        newEmail: null, // Email update is removed
        newPassword: newPassword.isNotEmpty ? newPassword : null,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      _showError('Error updating credentials: $e');
    }
  }

  // Show error messages
  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: const Text('Account Settings'),
        backgroundColor: AppColors.appBarColor,
      ),
      body: Center(
        // Centering the content on the screen
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: AppColors.formColor, // Card background color
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Password Update Section
                  const Text(
                    'Update Password',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _currentPasswordController,
                    obscureText: !_isPasswordVisible, // Control visibility
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                      labelStyle: TextStyle(color: Colors.white),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible =
                                !_isPasswordVisible; // Toggle visibility
                          });
                        },
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _newPasswordController,
                    obscureText: !_isPasswordVisible, // Control visibility
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      labelStyle: TextStyle(color: Colors.white),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible =
                                !_isPasswordVisible; // Toggle visibility
                          });
                        },
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _newPasswordConfirmController,
                    obscureText: !_isPasswordVisible, // Control visibility
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      labelStyle: TextStyle(color: Colors.white),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible =
                                !_isPasswordVisible; // Toggle visibility
                          });
                        },
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _updateCredentials,
                    child: const Text('Update Credentials'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.appBarColor,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255)),
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
