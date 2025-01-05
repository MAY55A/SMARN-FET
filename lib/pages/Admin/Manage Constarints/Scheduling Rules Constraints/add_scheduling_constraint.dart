import 'package:flutter/material.dart';
import 'package:smarn/CRUD_test.dart';
import 'package:smarn/models/constraint.dart';
import 'package:smarn/models/work_day.dart';
import 'package:smarn/pages/Admin/Manage%20Constarints/Scheduling%20Rules%20Constraints/scheduling_rules_view.dart';
import 'package:smarn/services/constraint_service.dart';
import 'package:smarn/pages/widgets/multi_select_dialog.dart'; // Import MultiSelectDialog

class AddSchedulingRuleForm extends StatefulWidget {
  @override
  _AddSchedulingRuleFormState createState() => _AddSchedulingRuleFormState();
}

class _AddSchedulingRuleFormState extends State<AddSchedulingRuleForm> {
  final _formKey = GlobalKey<FormState>();
  final _constraintService = ConstraintService();

  final _durationController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  List<SchedulingRuleType> _types = SchedulingRuleType.values;
  SchedulingRuleType _selectedType = SchedulingRuleType.workPeriod;
  List<WorkDay> _selectedDays = [];
  bool _isLoading = false;
  late int? _minDuration;
  late int? _maxDuration;

  @override
  void initState() {
    super.initState();
    _fetchDurations();
  }

  Future<void> _fetchDurations() async {
    final min = await _constraintService.getMinMaxDuration('min');
    final max = await _constraintService.getMinMaxDuration('max');
    setState(() {
      _minDuration = min;
      _maxDuration = max;
      if (min != null) {
        _types.remove(SchedulingRuleType.minActivityDuration);
      }
      if (max != null) {
        _types.remove(SchedulingRuleType.maxActivityDuration);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Scheduling Rule'),
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
                constraints: const BoxConstraints(maxWidth: 600),
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
                        items: _types
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
                      if (_selectedType == SchedulingRuleType.minActivityDuration ||
                          _selectedType == SchedulingRuleType.maxActivityDuration)
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
                            if (_selectedType == SchedulingRuleType.maxActivityDuration &&
                                _minDuration != null &&
                                int.parse(value) < _minDuration!) {
                              return 'Max Duration must be >= Min Duration: $_minDuration';
                            }
                            if (_selectedType == SchedulingRuleType.minActivityDuration &&
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
                      if (_selectedType == SchedulingRuleType.workPeriod ||
                          _selectedType == SchedulingRuleType.breakPeriod) ...[
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
                          onTap: () => _selectDays(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Select Applicable Days: ${_selectedDays.map((e) => e.name).join(', ')}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                if (_formKey.currentState?.validate() ?? false) {
                                  _addSchedulingRule();
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 129, 77, 139),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Submit'),
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

  Future<void> _addSchedulingRule() async {
    setState(() {
      _isLoading = true;
    });

    final newSchedulingRule = SchedulingRule(
      type: _selectedType,
      duration: int.tryParse(_durationController.text),
      startTime: _startTimeController.text.isEmpty ? null : _startTimeController.text,
      endTime: _endTimeController.text.isEmpty ? null : _endTimeController.text,
      applicableDays: _selectedDays.isEmpty ? null : _selectedDays,
    );
    final response = await _constraintService.createSchedulingRule(newSchedulingRule);
    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Scheduling Rule added successfully')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SchedulingRulesView()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'])),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

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
