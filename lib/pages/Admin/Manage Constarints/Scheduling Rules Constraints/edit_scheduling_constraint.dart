import 'package:flutter/material.dart';
import 'package:smarn/models/constraint.dart';
import 'package:smarn/models/work_day.dart';
import 'package:smarn/pages/widgets/multi_select_dialog.dart'; // Your existing multi-select dialog
import 'package:smarn/services/constraint_service.dart';

class EditSchedulingRuleForm extends StatefulWidget {
  final SchedulingRule schedulingRule;

  EditSchedulingRuleForm({required this.schedulingRule});

  @override
  _EditSchedulingRuleFormState createState() => _EditSchedulingRuleFormState();
}

class _EditSchedulingRuleFormState extends State<EditSchedulingRuleForm> {
  final _formKey = GlobalKey<FormState>();
  final _durationController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  late SchedulingRuleType _selectedType;
  late List<WorkDay> _selectedDays;

  @override
  void initState() {
    super.initState();
    _durationController.text = widget.schedulingRule.duration ?? '';
    _startTimeController.text = widget.schedulingRule.startTime ?? '';
    _endTimeController.text = widget.schedulingRule.endTime ?? '';
    _selectedType = widget.schedulingRule.type;
    _selectedDays = widget.schedulingRule.applicableDays ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Scheduling Rule')),
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
                onTap: () async {
                  final selected = await showDialog<List<WorkDay>>(
                    context: context,
                    builder: (context) {
                      return MultiSelectDialog(
                        items: WorkDay.values.map((e) => e.name).toList(),
                        selectedItems:
                            _selectedDays.map((e) => e.name).toList(),
                      );
                    },
                  );
                  if (selected != null) {
                    setState(() {
                      _selectedDays = selected
                          .map((name) => WorkDay.values
                              .firstWhere((e) => e.name == name))
                          .toList();
                    });
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Applicable Days',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(_selectedDays
                      .map((day) => day.name)
                      .join(', ')), // Display selected days
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final updatedSchedulingRule = SchedulingRule(
                      id: widget.schedulingRule.id,
                      type: _selectedType,
                      duration: _durationController.text,
                      startTime: _startTimeController.text,
                      endTime: _endTimeController.text,
                      applicableDays: _selectedDays,
                    );

                    ConstraintService()
                        .updateConstraint(
                            widget.schedulingRule.id, updatedSchedulingRule)
                        .then((response) {
                      if (response['success'] == true) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Scheduling Rule updated successfully')));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Failed to update Scheduling Rule')));
                      }
                    });
                  }
                },
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
