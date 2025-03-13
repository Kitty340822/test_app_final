import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateGradeForm extends StatefulWidget {
  @override
  State<UpdateGradeForm> createState() => _UpdateGradeFormState();
}

class _UpdateGradeFormState extends State<UpdateGradeForm> {
  CollectionReference gradesCollection =
      FirebaseFirestore.instance.collection('Scores');

  @override
  Widget build(BuildContext context) {
    final gradeData = ModalRoute.of(context)!.settings.arguments as dynamic;

    final studentNameController =
        TextEditingController(text: gradeData['student_name']);
    final subjectNameController =
        TextEditingController(text: gradeData['subject_name']);
    final scoreController =
        TextEditingController(text: gradeData['score'].toString());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink, // เปลี่ยนสี AppBar เป็นสีชมพู
        title: Center(
          child: Text(
            'Update Score',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // เพิ่มระยะห่างจากขอบ
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Update Score Entry',
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
                      fillColor: Colors.pink[50], // สีพื้นหลังอ่อน
                      filled: true, // ให้พื้นหลังมีสี
                    ),
                    readOnly: true, // ป้องกันไม่ให้แก้ไขชื่อของนิสิต
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
                    controller: scoreController,
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
                      double? score = double.tryParse(scoreController.text);
                      if (score != null) {
                        gradesCollection.doc(gradeData.id).update({
                          'student_name': studentNameController.text,
                          'subject_name': subjectNameController.text,
                          'score': score, // อัพเดตคะแนน
                        });
                        Navigator.pop(context); // ปิดหน้า UpdateForm
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please enter a valid number for score')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[300], // สีปุ่มเป็นชมพูอ่อน
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40), // ขนาดปุ่ม
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text(
                      'Update',
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
