import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Import the dart:convert library

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TodoPage(),
    );
  }
}

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  TextEditingController _taskController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  Future<void> _addTodo() async {
    String task = _taskController.text.trim();
    String date = _dateController.text.trim();
    if (task.isNotEmpty && date.isNotEmpty) {
      try {
        final response = await http.post(
          Uri.parse('http://localhost:3000/todos'), // Convert string to Uri object
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"task": task, "date": date}),
        );
        if (response.statusCode == 201) {
          print('ToDo added successfully');
          _taskController.clear();
          _dateController.clear();
        } else {
          print('Failed to add ToDo');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add ToDo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _taskController,
              decoration: InputDecoration(labelText: 'Task'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Date'),
            ),
            SizedBox(height: 20),
            ElevatedButton( // Changed RaisedButton to ElevatedButton
              onPressed: _addTodo,
              child: Text('Add ToDo'),
            ),
          ],
        ),
      ),
    );
  }
}
