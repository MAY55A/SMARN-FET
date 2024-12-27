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
    _durationController.text = widget.schedulingRule.duration?.toString() ?? '';
    _startTimeController.text = widget.schedulingRule.startTime ?? '';
    _endTimeController.text = widget.schedulingRule.endTime ?? '';
    _selectedType = widget.schedulingRule.type;
    _selectedDays = widget.schedulingRule.applicableDays ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Scheduling Rule'),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<SchedulingRuleType>(
                value: _selectedType,
                onChanged: (SchedulingRuleType? newValue) {
                  setState(() {
                    _selectedType = newValue!;
                  });
                },
                items: SchedulingRuleType.values
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(
                          type.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                    .toList(),
                dropdownColor: Colors.grey[800],
                decoration: InputDecoration(
                  labelText: 'Scheduling Type',
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_selectedType == SchedulingRuleType.minActivityDuration)
                TextFormField(
                  controller: _durationController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Duration',
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter duration';
                    }
                    return null;
                  },
                ),
              if (_selectedType == SchedulingRuleType.workPeriod ||
                  _selectedType == SchedulingRuleType.breakPeriod) ...[
                TextFormField(
                  controller: _startTimeController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Start Time',
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter start time';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _endTimeController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'End Time',
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter end time';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    final selected = await showDialog<List<String>>(
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
                      labelStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      _selectedDays.map((day) => day.name).join(', '),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final updatedSchedulingRule = SchedulingRule(
                      id: widget.schedulingRule.id,
                      type: _selectedType,
                      duration: _selectedType == SchedulingRuleType.minActivityDuration
                          ? int.tryParse(_durationController.text)
                          : null,
                      startTime: _selectedType != SchedulingRuleType.minActivityDuration
                          ? _startTimeController.text
                          : null,
                      endTime: _selectedType != SchedulingRuleType.minActivityDuration
                          ? _endTimeController.text
                          : null,
                      applicableDays: _selectedType != SchedulingRuleType.minActivityDuration
                          ? _selectedDays
                          : [],
                    );

                    ConstraintService()
                        .updateConstraint(
                            widget.schedulingRule.id!, updatedSchedulingRule)
                        .then((response) {
                      if (response['success'] == true) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                'Scheduling Rule updated successfully')));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Failed to update Scheduling Rule')));
                      }
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 129, 77, 139),
                ),
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
