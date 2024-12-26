import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smarn/services/auth_service.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({super.key});

  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final AuthService _authService = AuthService();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _newPasswordConfirmController = TextEditingController();

  Future<void> _updatePassword() async {
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _newPasswordConfirmController.text.trim();

    // Validation
    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      _showError('All fields are required.');
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
      // Get current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showError('No user is currently signed in');
        return;
      }

      // Create credentials
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      // Reauthenticate
      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully')),
      );
      Navigator.pop(context); // Go back to the previous screen
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'wrong-password':
          errorMessage = 'Current password is incorrect';
          break;
        case 'requires-recent-login':
          errorMessage = 'Please sign in again before updating your password';
          break;
        default:
          errorMessage = e.message ?? 'An error occurred';
      }
      _showError(errorMessage);
    } catch (e) {
      _showError('Error updating password: $e');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _newPasswordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Password'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.black, // Black background for the page
        child: Center(
          child: Card(
            color: Colors.grey[800], // Gray background for the card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // Rounded corners
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _currentPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Current Password',
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _newPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'New Password',
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _newPasswordConfirmController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirm New Password',
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _updatePassword,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Update Password',
                      style: TextStyle(fontSize: 16),
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
