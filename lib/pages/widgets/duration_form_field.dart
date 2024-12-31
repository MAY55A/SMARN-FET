import 'package:flutter/material.dart';
import 'package:smarn/services/time_service.dart';

Widget durationFormField(
    int minDuration, int maxDuration, void Function(int?)? onChange,
    [int? selected]) {
  var availableDurations = List.generate(
    ((maxDuration - minDuration) ~/ minDuration) + 1,
    (index) => minDuration + (index * minDuration),
  );
  return DropdownButtonFormField<int>(
    value: selected,
    decoration: const InputDecoration(
      labelText: 'Duration',
      border: OutlineInputBorder(),
    ),
    items: availableDurations
        .map((duration) => DropdownMenuItem(
            value: duration,
            child: Text(
              TimeService.minutesToTime(duration),
              style: const TextStyle(color: Colors.purple),
            )))
        .toList(),
    onChanged: onChange,
    validator: (value) {
      if (value == null || value < minDuration) {
        return 'Duration must be at least $minDuration mins.';
      }
      return null;
    },
  );
}
