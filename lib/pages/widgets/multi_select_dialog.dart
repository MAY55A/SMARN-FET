import 'package:flutter/material.dart';

class MultiSelectDialog extends StatefulWidget {
  final List<String> items;
  final List<String> selectedItems;

  const MultiSelectDialog({
    Key? key,
    required this.items,
    required this.selectedItems,
  }) : super(key: key);

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  late List<String> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedItems = List.from(widget.selectedItems); // Create a copy of selected items
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[800], // Set the background color to gray
      title: const Text(
        "Select Available Days",
        style: TextStyle(color: Colors.white), // Set title text color to white
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items.map((item) {
            return CheckboxListTile(
              title: Text(
                item,
                style: const TextStyle(color: Colors.white), // Set item text color to white
              ),
              value: _selectedItems.contains(item),
              activeColor: const Color.fromARGB(255, 129, 77, 139), // Checkbox color when selected
              onChanged: (bool? selected) {
                setState(() {
                  if (selected != null) {
                    if (selected) {
                      _selectedItems.add(item);
                    } else {
                      _selectedItems.remove(item);
                    }
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Return the selected items back to the parent widget
            Navigator.of(context).pop(_selectedItems);
          },
          child: const Text(
            "Done",
            style: TextStyle(color: Colors.white), // Set button text color to white
          ),
        ),
      ],
    );
  }
}
