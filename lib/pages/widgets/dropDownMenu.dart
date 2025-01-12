import 'package:flutter/material.dart';

Widget filterMenu(List<String> filterValues, String selectedValue,
    String filter, void Function(String) filterFunction) {
  return PopupMenuButton<String>(
    onSelected: filterFunction,
    itemBuilder: (BuildContext context) {
      return ['All', ...filterValues].map((String value) {
        return PopupMenuItem<String>(
          value: value,
          child: Container(
            width: 200, // Set custom width for menu items
            child: Text(
              value,
              overflow:
                  TextOverflow.visible, // Allow text to exceed constraints
              style: const TextStyle(color: Colors.black),
            ),
          ),
        );
      }).toList();
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            selectedValue == 'All' ? "All $filter" : selectedValue,
            style: const TextStyle(color: Colors.white),
          ),
          const Icon(Icons.arrow_drop_down, color: Colors.white),
        ],
      ),
    ),
  );
}

Widget activityDropdownMenu(String type, dynamic selected, List list,
    void Function(dynamic)? onChange) {
  return DropdownButton<dynamic>(
    padding: const EdgeInsets.only(left: 20, right: 20),
    value: selected,
    hint: Text("Select $type", style: const TextStyle(color: Colors.white)),
    disabledHint:
        Text("No $type available", style: const TextStyle(color: Colors.grey)),
    onChanged: onChange,
    items: list.map<DropdownMenuItem<dynamic>>((dynamic value) {
      return DropdownMenuItem<dynamic>(
        value: value,
        child: Text(value is String ? value : value.name,
            style: const TextStyle(color: Colors.white)),
      );
    }).toList(),
    dropdownColor: Colors.black,
  );
}
