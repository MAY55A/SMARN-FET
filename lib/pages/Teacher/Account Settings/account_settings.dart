import 'package:flutter/material.dart';
import 'package:smarn/pages/Teacher/Account%20Settings/update_phone_page.dart';
import 'update_email_page.dart';

import 'update_password_page.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UpdateEmailPage()),
                );
              },
              child: const Text('Update Email'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UpdatePhoneNumberPage()),
                );
              },
              child: const Text('Update Phone Number'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UpdatePasswordPage()),
                );
              },
              child: const Text('Update Password'),
            ),
          ],
        ),
      ),
    );
  }
}
