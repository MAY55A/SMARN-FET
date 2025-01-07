import 'package:flutter/material.dart';
import 'package:smarn/services/timetable_generation_service.dart';

class GenerationScreen extends StatefulWidget {
  @override
  _GenerationScreenState createState() => _GenerationScreenState();
}

class _GenerationScreenState extends State<GenerationScreen> {
  final TimetableGenerationService _generationService =
      TimetableGenerationService();
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _startGeneration();
  }

  void _startGeneration() {
    setState(() {
      _isGenerating = true;
    });

    _generationService.generateTimetables().then((_) {
      setState(() {
        _isGenerating = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generation Logs"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black, // Set background color to black
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder<List<String>>(
              valueListenable: _generationService.logs,
              builder: (context, logs, child) {
                return ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        logs[index],
                        style: const TextStyle(
                            color: Colors.white), // Change text color to white
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (_isGenerating)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          ElevatedButton(
            onPressed: _isGenerating
                ? null
                : () {
                    Navigator.pop(context); // Close the screen when finished
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Red color for the button
            ),
            child: Text(
              _isGenerating ? "Generating..." : "Close",
              style: const TextStyle(
                  color: Colors.white), // Change text color to white
            ),
          ),
        ],
      ),
    );
  }
}
