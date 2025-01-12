  import 'package:flutter/material.dart';

void showDeleteConfirmationDialog(BuildContext context, String deletedEntity, VoidCallback onDelete) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text(
              'Are you sure you want to delete this $deletedEntity ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog without deleting
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                onDelete(); // Execute delete action
              },
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.red),
                  foregroundColor: WidgetStatePropertyAll(Colors.white)),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }