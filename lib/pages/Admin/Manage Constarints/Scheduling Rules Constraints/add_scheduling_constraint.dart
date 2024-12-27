import 'package:flutter/material.dart';
import 'package:smarn/models/constraint.dart';
import 'package:smarn/models/work_day.dart';
import 'package:smarn/services/constraint_service.dart';
import 'package:smarn/pages/widgets/multi_select_dialog.dart'; // Import MultiSelectDialog

class AddSchedulingRuleForm extends StatefulWidget {
  @override
  _AddSchedulingRuleFormState createState() => _AddSchedulingRuleFormState();
}

class _AddSchedulingRuleFormState extends State<AddSchedulingRuleForm> {
  final _formKey = GlobalKey<FormState>();
  final _durationController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  SchedulingRuleType _selectedType = SchedulingRuleType.workPeriod;
  List<WorkDay> _selectedDays = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Scheduling Rule')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<SchedulingRuleType>(
                value: _selectedType,
                onChanged: (SchedulingRuleType? newValue) {
                  setState(() {
                    _selectedType = newValue!;
                  });
                },
                items: SchedulingRuleType.values
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.name),
                        ))
                    .toList(),
                decoration: InputDecoration(labelText: 'Scheduling Type'),
              ),
              TextFormField(
                controller: _durationController,
                decoration: InputDecoration(labelText: 'Duration'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter duration';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _startTimeController,
                decoration: InputDecoration(labelText: 'Start Time'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter start time';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _endTimeController,
                decoration: InputDecoration(labelText: 'End Time'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter end time';
                  }
                  return null;
                },
              ),
              GestureDetector(
                onTap: () => _selectDays(context),  // Open multi-select dialog
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select Applicable Days: ${_selectedDays.map((e) => e.name).join(', ')}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.white),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final newSchedulingRule = SchedulingRule(
                      id: '',  // Generate or set the ID
                      type: _selectedType,
                      duration: _durationController.text,
                      startTime: _startTimeController.text,
                      endTime: _endTimeController.text,
                      applicableDays: _selectedDays,
                    );

                    ConstraintService().createSchedulingRule(newSchedulingRule)
                        .then((response) {
                          if (response['success'] == true) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Scheduling Rule added successfully')));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add Scheduling Rule')));
                          }
                        });
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to select days using the multi-select dialog
  Future<void> _selectDays(BuildContext context) async {
    final selectedDays = await showDialog<List<String>>(
      context: context,
      builder: (context) {
        return MultiSelectDialog(
          items: WorkDay.values.map((day) => day.name).toList(),
          selectedItems: _selectedDays.map((day) => day.name).toList(),
        );
      },
    );

    if (selectedDays != null) {
      setState(() {
        _selectedDays = selectedDays
            .map((day) => WorkDay.values.firstWhere((e) => e.name == day))
            .toList();
      });
    }
  }
}
