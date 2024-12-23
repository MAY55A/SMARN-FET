import 'package:flutter/material.dart';
import 'package:smarn/services/auth_service.dart';

class UpdateEmailPage extends StatefulWidget {
  const UpdateEmailPage({super.key});

  @override
  _UpdateEmailPageState createState() => _UpdateEmailPageState();
}

class _UpdateEmailPageState extends State<UpdateEmailPage> {
  final AuthService _authService = AuthService();
  final _emailController = TextEditingController();
  final _currentPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentEmail();
  }

  void _loadCurrentEmail() async {
    final user = _authService.getCurrentUser();
    if (user != null) {
      setState(() {
        _emailController.text = user.email ?? '';
      });
    }
  }

  Future<void> _updateEmail() async {
    final newEmail = _emailController.text.trim();
    final currentPassword = _currentPasswordController.text.trim();

    if (newEmail.isEmpty) {
      _showError('Email cannot be empty.');
      return;
    }

    if (currentPassword.isEmpty) {
      _showError('Please enter your current password.');
      return;
    }

    try {
      final result = await _authService.updateUserCredentials(
        newEmail: newEmail,
        currentPassword: currentPassword,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
      Navigator.pop(context); // Go back to the previous screen
    } catch (e) {
      _showError('Error updating email: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Email')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'New Email'),
            ),
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Current Password'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateEmail,
              child: const Text('Update Email'),
            ),
          ],
        ),
      ),
    );
  }
}
