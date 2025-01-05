import 'package:flutter/material.dart';
import 'package:smarn/models/constraint.dart';
import 'package:smarn/models/work_day.dart';
import 'package:smarn/pages/widgets/multi_select_dialog.dart';
import 'package:smarn/services/constraint_service.dart';

class EditSchedulingRuleForm extends StatefulWidget {
  final SchedulingRule schedulingRule;

  EditSchedulingRuleForm({required this.schedulingRule});

  @override
  _EditSchedulingRuleFormState createState() => _EditSchedulingRuleFormState();
}

class _EditSchedulingRuleFormState extends State<EditSchedulingRuleForm> {
  final _formKey = GlobalKey<FormState>();
  final _constraintService = ConstraintService();

  final _durationController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  late List<WorkDay>? _selectedDays;
  bool _isLoading = false;
  bool _isActive = true;
  late int? _minDuration;
  late int? _maxDuration;

  @override
  void initState() {
    super.initState();
    _fetchDurations();

    if (widget.schedulingRule.duration != null) {
      _durationController.text = widget.schedulingRule.duration!.toString();
    }
    if (widget.schedulingRule.startTime != null) {
      _startTimeController.text = widget.schedulingRule.startTime!;
    }
    if (widget.schedulingRule.endTime != null) {
      _endTimeController.text = widget.schedulingRule.endTime!;
    }
    _selectedDays = widget.schedulingRule.applicableDays;
    _isActive = widget.schedulingRule.isActive;
  }

  Future<void> _fetchDurations() async {
    final min = await _constraintService.getMinMaxDuration('min');
    final max = await _constraintService.getMinMaxDuration('max');
    setState(() {
      _minDuration = min;
      _maxDuration = max;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Scheduling Rule'),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.all(16),
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 600,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.schedulingRule.type.name,
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      if (widget.schedulingRule.type == SchedulingRuleType.minActivityDuration ||
                          widget.schedulingRule.type == SchedulingRuleType.maxActivityDuration)
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
                            if (value == null || int.tryParse(value) == null) {
                              return 'Please enter a duration';
                            }
                            if (widget.schedulingRule.type == SchedulingRuleType.maxActivityDuration &&
                                _minDuration != null &&
                                int.parse(value) < _minDuration!) {
                              return 'Max Duration must be >= Min Duration: $_minDuration';
                            }
                            if (widget.schedulingRule.type == SchedulingRuleType.minActivityDuration &&
                                _maxDuration != null &&
                                int.parse(value) > _maxDuration!) {
                              return 'Min Duration must be <= Max Duration: $_maxDuration';
                            }
                            if (int.parse(value) < 30) {
                              return 'Duration must be at least 30 minutes';
                            }
                            return null;
                          },
                        ),
                      if (widget.schedulingRule.type == SchedulingRuleType.workPeriod ||
                          widget.schedulingRule.type == SchedulingRuleType.breakPeriod) ...[
                        const SizedBox(height: 16),
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
                                  selectedItems: _selectedDays!.map((e) => e.name).toList(),
                                );
                              },
                            );
                            if (selected != null) {
                              setState(() {
                                _selectedDays = selected
                                    .map((name) => WorkDay.values.firstWhere((e) => e.name == name))
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
                              _selectedDays!.map((day) => day.name).join(', '),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Active:',
                            style: TextStyle(color: Colors.white),
                          ),
                          Switch(
                            value: _isActive,
                            onChanged: (value) {
                              setState(() {
                                _isActive = value;
                              });
                            },
                            activeColor: const Color.fromARGB(255, 129, 77, 139),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            final updatedSchedulingRule = SchedulingRule(
                              id: widget.schedulingRule.id,
                              type: widget.schedulingRule.type,
                              duration: int.tryParse(_durationController.text),
                              startTime: _startTimeController.text.isEmpty
                                  ? null
                                  : _startTimeController.text,
                              endTime: _endTimeController.text.isEmpty
                                  ? null
                                  : _endTimeController.text,
                              applicableDays: _selectedDays,
                              isActive: _isActive,
                            );

                            if (widget.schedulingRule.equals(updatedSchedulingRule)) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('No changes were made to the constraint'),
                              ));
                            } else {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirm Update'),
                                  content: const Text('Are you sure you want to update this scheduling rule?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: const Text('Confirm'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                setState(() {
                                  _isLoading = true;
                                });
                                ConstraintService()
                                    .updateConstraint(widget.schedulingRule.id!, updatedSchedulingRule)
                                    .then((response) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  if (response['success'] == true) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Scheduling Rule updated successfully')),
                                    );
                                    Navigator.of(context).pop();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Failed to update Scheduling Rule')),
                                    );
                                  }
                                });
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 129, 77, 139),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Save Changes'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
