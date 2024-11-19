import 'package:flutter/material.dart';
import 'package:smarn/models/building.dart';
import 'package:smarn/pages/widgets/canstants.dart';

class AddBuilding extends StatelessWidget {
  const AddBuilding({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController longNameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        
        title: const Text('Add Building',style: TextStyle(color:Colors.white),),
        backgroundColor: AppColors.appBarColor      ),
      body: Container(
        color: Colors.black, // Black background color
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height:20.0),
            // Form fields
            _buildTextField(
              controller: nameController,
              labelText: 'Name',
            ),
            const SizedBox(height: 16.0),
            _buildTextField(
              controller: longNameController,
              labelText: 'Long Name',
            ),
            const SizedBox(height: 16.0),
            _buildTextField(
              controller: descriptionController,
              labelText: 'Description',
            ),
            const SizedBox(height: 24.0),
            // Save Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    Building(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameController.text,
                      longName: longNameController.text,
                      description: descriptionController.text,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 129, 77, 139),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text('Save', style: TextStyle(fontSize: 16.0,color:Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // A reusable text field builder for consistency
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 167, 167, 167)),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 105, 105, 105)),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.purple),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        filled: true,
        fillColor: Colors.grey[850], // Slightly lighter black for field background
      ),
    );
  }
}
