import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddGradeForm extends StatefulWidget {
  @override
  State<AddGradeForm> createState() => _AddGradeFormState();
}

class _AddGradeFormState extends State<AddGradeForm> {
  final studentNameController = TextEditingController();
  final subjectNameController = TextEditingController();
  final pointController = TextEditingController();

  CollectionReference gradesCollection =
      FirebaseFirestore.instance.collection('Scores');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink, // เปลี่ยนสี AppBar เป็นสีชมพู
        title: Center(
          child: Text(
            'Add Points',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // เพิ่มการเว้นระยะจากขอบ
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New Score Entry',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink[800], // ใช้สีชมพูเข้มสำหรับหัวข้อ
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: studentNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter Student Name',
                      icon: Icon(Icons.person, color: Colors.pink), // ใช้ไอคอนสีชมพู
                      fillColor: Colors.pink[50], // เพิ่มสีพื้นหลังอ่อน
                      filled: true, // ให้พื้นหลังมีสี
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: subjectNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter Subject Name',
                      icon: Icon(Icons.book, color: Colors.pink),
                      fillColor: Colors.pink[50],
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: pointController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter Score',
                      icon: Icon(Icons.grade, color: Colors.pink),
                      fillColor: Colors.pink[50],
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      double? points = double.tryParse(pointController.text);
                      if (points != null) {
                        gradesCollection.add({
                          'student_name': studentNameController.text,
                          'subject_name': subjectNameController.text,
                          'score': points
                        });
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please enter a valid number for points')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[300], // สีปุ่มเป็นชมพูอ่อน
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40), // เพิ่มขนาดของปุ่ม
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
