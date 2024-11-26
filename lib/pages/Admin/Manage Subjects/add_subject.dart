import 'package:flutter/material.dart';
import 'package:smarn/models/subject.dart';
import 'package:smarn/pages/widgets/canstants.dart';
import 'package:smarn/services/subject_service.dart';

class AddSubject extends StatefulWidget {
  const AddSubject({super.key});

  @override
  _AddSubjectState createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _longNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SubjectService _subjectService = SubjectService();

  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final subject = Subject(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        longName: _longNameController.text,
        description: _descriptionController.text,
      );

      setState(() => _isLoading = true);
      try {
        final result = await _subjectService.addSubject(subject);
        setState(() => _isLoading = false);

        if (result['success']) {
          Navigator.pop(context, subject);
        } else {
          throw result['message'];
        }
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding subject: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Add Subject"),
        backgroundColor: AppColors.appBarColor,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subject Name
                      _buildTextField(_nameController, "Subject Name"),
                      const SizedBox(height: 16),

                      // Full Name
                      _buildTextField(_longNameController, "Full Name"),
                      const SizedBox(height: 16),

<<<<<<< HEAD
                // Description TextFormField
                TextFormField(
                  controller: _descriptionController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Description",
                    labelStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Teacher Selection CheckboxListTiles
                const Text(
                  "Select Teachers",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: availableTeachers.map((teacher) {
                    return Theme(
                      data: ThemeData(unselectedWidgetColor: Colors.white),
                      child: CheckboxListTile(
                        title: Text(
                          teacher.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        activeColor: AppColors.appBarColor,
                        value: selectedTeachers.contains(teacher),
                        onChanged: (bool? selected) {
                          setState(() {
                            if (selected == true) {
                              selectedTeachers.add(teacher);
                            } else {
                              selectedTeachers.remove(teacher);
                            }
                          });
                        },
=======
                      // Description
                      _buildTextField(
                        _descriptionController,
                        "Description",
                        maxLines: 3,
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81
                      ),
                      const SizedBox(height: 16),

<<<<<<< HEAD
                // Add Subject Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pop(
                          context,
                          Subject(
                            id: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            name: _nameController.text,
                            longName: _longNameController.text,
                            description: _descriptionController.text,
                            teachers: selectedTeachers,
=======
                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.appBarColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
>>>>>>> ffb639349ab96e8f4b6bef92ef03bacc9b62cf81
                          ),
                          child: const Text(
                            "Add Subject",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }
}
