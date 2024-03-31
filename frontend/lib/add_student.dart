import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddStudentPage extends StatefulWidget {
  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _sinhalaController = TextEditingController();
  TextEditingController _tamilController = TextEditingController();
  TextEditingController _mathsController = TextEditingController();
  TextEditingController _scienceController = TextEditingController();
  TextEditingController _ictController = TextEditingController();
  TextEditingController _artController = TextEditingController();

  String? _validateName(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter student name';
    }
    return null;
  }

  String? _validateMarks(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter marks';
    }
    final mark = int.tryParse(value!);
    if (mark == null || mark < 0 || mark > 100) {
      return 'Marks must be between 0 and 100';
    }
    return null;
  }

  Future<void> _addStudent() async {
    String name = _nameController.text.trim();
    String sinhala = _sinhalaController.text.trim();
    String tamil = _tamilController.text.trim();
    String maths = _mathsController.text.trim();
    String science = _scienceController.text.trim();
    String ict = _ictController.text.trim();
    String art = _artController.text.trim();

    if (_validateName(name) != null ||
        _validateMarks(sinhala) != null ||
        _validateMarks(tamil) != null ||
        _validateMarks(maths) != null ||
        _validateMarks(science) != null ||
        _validateMarks(ict) != null ||
        _validateMarks(art) != null) {
      return; 
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.8.171:3000/marks'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "sinhala": sinhala,
          "tamil": tamil,
          "maths": maths,
          "science": science,
          "ict": ict,
          "art": art
        }),
      );
      if (response.statusCode == 201) {
        print('Student added successfully');
        _nameController.clear();
        _sinhalaController.clear();
        _tamilController.clear();
        _mathsController.clear();
        _scienceController.clear();
        _ictController.clear();
        _artController.clear();
      } else {
        print('Failed to add student');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 212, 178, 126),
        title: Text('Add Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Student Name'),
              validator: _validateName,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _sinhalaController,
                    decoration: InputDecoration(labelText: 'Sinhala Mark'),
                    keyboardType: TextInputType.number,
                    validator: _validateMarks,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: TextFormField(
                    controller: _tamilController,
                    decoration: InputDecoration(labelText: 'Tamil Mark'),
                    keyboardType: TextInputType.number,
                    validator: _validateMarks,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _mathsController,
                    decoration: InputDecoration(labelText: 'Maths Mark'),
                    keyboardType: TextInputType.number,
                    validator: _validateMarks,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: TextFormField(
                    controller: _scienceController,
                    decoration: InputDecoration(labelText: 'Science Mark'),
                    keyboardType: TextInputType.number,
                    validator: _validateMarks,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _ictController,
                    decoration: InputDecoration(labelText: 'ICT Mark'),
                    keyboardType: TextInputType.number,
                    validator: _validateMarks,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: TextFormField(
                    controller: _artController,
                    decoration: InputDecoration(labelText: 'Art Mark'),
                    keyboardType: TextInputType.number,
                    validator: _validateMarks,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_validateName(_nameController.text) == null &&
                    _validateMarks(_sinhalaController.text) == null &&
                    _validateMarks(_tamilController.text) == null &&
                    _validateMarks(_mathsController.text) == null &&
                    _validateMarks(_scienceController.text) == null &&
                    _validateMarks(_ictController.text) == null &&
                    _validateMarks(_artController.text) == null) {
                  _addStudent();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please fix errors before submitting.'),
                    backgroundColor: Colors.red,
                  ));
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 115, 193, 238)),
              ),
              child: Text('Add Student & Mark'),
            ),
          ],
        ),
      ),
    );
  }
}
