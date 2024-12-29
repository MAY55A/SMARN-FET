import 'package:flutter/material.dart';
import 'package:smarn/models/constraint.dart';
import 'package:smarn/models/work_day.dart';

class SchedulingRuleDetails extends StatelessWidget {
  final SchedulingRule rule;

  const SchedulingRuleDetails({super.key, required this.rule});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduling Rule Details'),
        backgroundColor: const Color.fromARGB(255, 129, 77, 139),
      ),
      body: Container(
        height: 800,
        color: Colors.black,
        child: Center( // Center the card in the body
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Colors.grey[850], // Card background color
              elevation: 8, // Shadow effect
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView( // Make the entire content scrollable
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('ID:', rule.id ?? 'Unknown'),
                      _buildDetailRow('Type:', rule.type.toString().split('.').last),
                      if (rule.duration != null) _buildDetailRow('Duration:', rule.duration.toString()),
                      if (rule.startTime != null) _buildDetailRow('Start Time:', rule.startTime ?? 'Not Available'),
                      if (rule.endTime != null) _buildDetailRow('End Time:', rule.endTime ?? 'Not Available'),
                      if (rule.applicableDays != null && rule.applicableDays!.isNotEmpty) 
                        _buildWorkDaysSection(rule.applicableDays!),
                      _buildDetailRow('Active:', rule.isActive ? 'Yes' : 'No'), // New row for active state
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // A new method to display workdays as small cards, each on a new line
  Widget _buildWorkDaysSection(List<WorkDay> workDays) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Applicable Days:',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0, // Horizontal space between cards
            runSpacing: 4.0, // Vertical space between rows
            children: workDays.map((day) {
              return Chip(
                label: Text(
                  day.toString().split('.').last, // Assuming WorkDay is an enum
                  style: const TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.white,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
