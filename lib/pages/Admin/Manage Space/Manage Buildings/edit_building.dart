import 'package:flutter/material.dart';
import 'package:smarn/models/building.dart';
import 'package:smarn/pages/widgets/canstants.dart';
import 'package:smarn/services/building_service.dart';

class EditBuilding extends StatelessWidget {
  final Building building;

  const EditBuilding({super.key, required this.building});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: building.name);
    final TextEditingController longNameController =
        TextEditingController(text: building.longName);
    final TextEditingController descriptionController =
        TextEditingController(text: building.description);
    final BuildingService buildingService = BuildingService();

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Edit Building', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.appBarColor,
      ),
      body: Container(
        color: Colors.black, // Black background color
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
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
                onPressed: () async {
                  // Validate inputs
                  if (nameController.text.isEmpty ||
                      longNameController.text.isEmpty ||
                      descriptionController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please fill in all fields')),
                    );
                    return;
                  }

                  // Create updated building object
                  Building updatedBuilding = Building(
                    id: building.id,
                    name: nameController.text,
                    longName: longNameController.text,
                    description: descriptionController.text,
                  );

                  if (!updatedBuilding.equals(building)) {
                    // Call the service to update the building
                    final result = await buildingService.updateBuilding(
                        building.id!, updatedBuilding);

                    if (result['success'] == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Building updated successfully!')),
                      );
                      Navigator.pop(context,
                          updatedBuilding); // Return the updated building to the previous screen
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${result['message']}')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('No changes were made to the building')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 129, 77, 139),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable text field builder
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 159, 159, 159)),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 118, 118, 118)),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.purple),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        filled: true,
        fillColor:
            Colors.grey[850], // Slightly lighter black for field background
      ),
    );
  }
}
