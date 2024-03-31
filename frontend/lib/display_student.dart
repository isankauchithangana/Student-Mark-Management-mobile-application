import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DisplayStudentsPage extends StatefulWidget {
  @override
  _DisplayStudentsPageState createState() => _DisplayStudentsPageState();
}

class _DisplayStudentsPageState extends State<DisplayStudentsPage> {
  List<Map<String, dynamic>> _students = [];

  Future<void> _fetchStudents() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.8.171:3000/marks'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _students = data.map((student) {
            return {
              'id': student['_id'],
              'name': student['name'],
              'sinhala': student['sinhala'],
              'tamil': student['tamil'],
              'maths': student['maths'],
              'science': student['science'],
              'ict': student['ict'],
              'art': student['art'],
              'showMarks': false, // Default to hide marks
            };
          }).toList();
        });
      } else {
        print('Failed to fetch students');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _deleteStudent(String id) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this student?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Return false when cancel is pressed
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Return true when delete is pressed
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      try {
        final response = await http.delete(
          Uri.parse('http://192.168.8.171:3000/marks/$id'),
        );
        if (response.statusCode == 200) {
          // If deletion is successful, fetch students again to update the list
          _fetchStudents();
        } else {
          print('Failed to delete student');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  Future<void> _editStudent(
    String id,
    String newName,
    String newSinhala,
    String newTamil,
    String newMaths,
    String newScience,
    String newIct,
    String newArt,
  ) async {
    try {
      // Parse string marks to integers
      final intSinhala = int.parse(newSinhala);
      final intTamil = int.parse(newTamil);
      final intMaths = int.parse(newMaths);
      final intScience = int.parse(newScience);
      final intIct = int.parse(newIct);
      final intArt = int.parse(newArt);

      final response = await http.put(
        Uri.parse('http://192.168.8.171:3000/marks/$id'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": newName,
          "sinhala": intSinhala.toString(), 
          "tamil": intTamil.toString(), 
          "maths": intMaths.toString(), 
          "science": intScience.toString(), 
          "ict": intIct.toString(), 
          "art": intArt.toString(), 
        }),
      );
      if (response.statusCode == 200) {
        // If update is successful, fetch students again to update the list
        _fetchStudents();
      } else {
        print('Failed to update student');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 212, 178, 126),
        title: Text('Saved Students'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _students.length,
                itemBuilder: (context, index) {
                  final student = _students[index];
                  return Card(
                    color: Color.fromARGB(255, 245, 211, 185),
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
  title: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween, 
    children: [
      Expanded(
        child: Text(
          '${student['name']}',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 16),
        ),
      ),
      Row(
        children: [
          IconButton(
            color: Color.fromARGB(255, 15, 2, 61),
            icon: Icon(student['showMarks']
                ? Icons.visibility_off
                : Icons.visibility),
            onPressed: () {
              // Toggle visibility of marks for this student
              setState(() {
                student['showMarks'] =
                    !(student['showMarks'] ?? false);
              });
            },
          ),
          IconButton(
            color: Color.fromARGB(255, 1, 34, 9),
            icon: Icon(Icons.edit),
            onPressed: () {
              _showEditDialog(student);
            },
          ),
          IconButton(
            color: Color.fromARGB(255, 99, 1, 1),
            icon: Icon(Icons.delete),
            onPressed: () {
              // Call function to delete student
              _deleteStudent(student['id']);
            },
          ),
        ],
      ),
    ],
  ),
  subtitle: Visibility(
  visible: student['showMarks'] == true,
  child: DataTable(
    columns: [
      DataColumn(label: Text('Subject')),
      DataColumn(label: Text('Marks')),
    ],
    rows: [
      DataRow(cells: [
        DataCell(Text('Sinhala')),
        DataCell(Text('${student['sinhala'] ?? ''}')),
      ]),
      DataRow(cells: [
        DataCell(Text('Tamil')),
        DataCell(Text('${student['tamil'] ?? ''}')),
      ]),
      DataRow(cells: [
        DataCell(Text('Maths')),
        DataCell(Text('${student['maths'] ?? ''}')),
      ]),
      DataRow(cells: [
        DataCell(Text('Science')),
        DataCell(Text('${student['science'] ?? ''}')),
      ]),
      DataRow(cells: [
        DataCell(Text('ICT')),
        DataCell(Text('${student['ict'] ?? ''}')),
      ]),
      DataRow(cells: [
        DataCell(Text('Art')),
        DataCell(Text('${student['art'] ?? ''}')),
      ]),
    ],
  ),
),

),

                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(Map<String, dynamic> student) {
    String newName = student['name'];
    String newSinhala = student['sinhala'].toString();
    String newTamil = student['tamil'].toString();
    String newMaths = student['maths'].toString();
    String newScience = student['science'].toString();
    String newIct = student['ict'].toString();
    String newArt = student['art'].toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Student'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: newName,
                  decoration: InputDecoration(labelText: 'Student Name'),
                  onChanged: (value) {
                    newName = value;
                  },
                ),
                TextFormField(
                  initialValue: newSinhala,
                  decoration: InputDecoration(labelText: 'Sinhala Mark'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    newSinhala = value;
                  },
                ),
                TextFormField(
                  initialValue: newTamil,
                  decoration: InputDecoration(labelText: 'Tamil Mark'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    newTamil = value;
                  },
                ),
                TextFormField(
                  initialValue: newMaths,
                  decoration: InputDecoration(labelText: 'Maths Mark'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    newMaths = value;
                  },
                ),
                TextFormField(
                  initialValue: newScience,
                  decoration: InputDecoration(labelText: 'Science Mark'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    newScience = value;
                  },
                ),
                TextFormField(
                  initialValue: newIct,
                  decoration: InputDecoration(labelText: 'ICT Mark'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    newIct = value;
                  },
                ),
                TextFormField(
                  initialValue: newArt,
                  decoration: InputDecoration(labelText: 'Art Mark'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    newArt = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                _editStudent(student['id'], newName, newSinhala, newTamil,
                    newMaths, newScience, newIct, newArt);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
