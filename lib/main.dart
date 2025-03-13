import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import './addForm.dart';
import './updateForm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.pink, // ใช้สีชมพูเป็นธีมหลัก
      scaffoldBackgroundColor: Colors.pink[50], // ตั้งพื้นหลังเป็นสีชมพูอ่อน
      appBarTheme: AppBarTheme(
        color: Colors.pink, // ใช้สีชมพูสำหรับ AppBar
        titleTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int screenIndex = 0;

  final mobileScreens = [
    Home(),
    Search(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Score Management',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: mobileScreens[screenIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            screenIndex = 1;
          });
          Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddGradeForm()))
              .then((_) {
            setState(() {
              screenIndex = 0;
            });
          });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        backgroundColor: Colors.pink, // เปลี่ยนสีปุ่มให้เป็นสีชมพู
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.pink[300], // ใช้สีชมพูอ่อนสำหรับ Bottom Bar
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    screenIndex = 0;
                  });
                },
                icon: Icon(
                  Icons.home,
                  color: screenIndex == 0
                      ? Colors.pink[900]
                      : Colors.white,
                )),
            IconButton(
                onPressed: () {
                  setState(() {
                    screenIndex = 1;
                  });
                },
                icon: Icon(
                  Icons.search,
                  color: screenIndex == 1
                      ? Colors.pink[900]
                      : Colors.white,
                )),
          ],
        ),
      ),
    );
  }
}

//------------- Home page ------------- 
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CollectionReference gradeCollection =
      FirebaseFirestore.instance.collection('Scores'); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: gradeCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var gradeDoc = snapshot.data!.docs[index];

                return Slidable(
                  startActionPane: ActionPane(
                    motion: DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {},
                        backgroundColor: Colors.pink,
                        icon: Icons.share,
                        label: 'Share',
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          // ไปที่หน้าฟอร์มแก้ไข
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateGradeForm(),
                              settings: RouteSettings(arguments: gradeDoc),
                            ),
                          );
                        },
                        backgroundColor: Colors.green,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          gradeCollection.doc(gradeDoc.id).delete();
                        },
                        backgroundColor: Colors.red,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(gradeDoc['student_name'], style: TextStyle(color: Colors.pink[800], fontWeight: FontWeight.bold)),
                    subtitle: Text('${gradeDoc['score']} points', style: TextStyle(color: Colors.pink[600])),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

//------------- Search page ------------- 
class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Search', style: TextStyle(fontSize: 30, color: Colors.pink[700]))],
        ),
      ),
    );
  }
}

//------------- UpdateGradeForm ------------- 
class UpdateGradeForm extends StatefulWidget {
  @override
  State<UpdateGradeForm> createState() => _UpdateGradeFormState();
}

class _UpdateGradeFormState extends State<UpdateGradeForm> {
  @override
  Widget build(BuildContext context) {
    final gradeData = ModalRoute.of(context)!.settings.arguments as dynamic;
    final studentNameController = TextEditingController(text: gradeData['student_name']);
    final subjectNameController = TextEditingController(text: gradeData['subject_name']);
    final scoreController = TextEditingController(text: gradeData['score'].toString());

    CollectionReference gradeCollection = FirebaseFirestore.instance.collection('Scores');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink, // สีชมพูสำหรับ AppBar
        title: Center(
          child: Text(
            'Update Points',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            child: Column(
              children: [
                Text(
                  'Update Grade Entry',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.pink[900]),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: studentNameController,
                  decoration: InputDecoration(
                    hintText: 'Student Name',
                    icon: Icon(Icons.person),
                    fillColor: Colors.pink[100], // สีพื้นหลังอ่อน
                    filled: true,
                  ),
                  readOnly: true, // ป้องกันไม่ให้แก้ไขชื่อของนิสิต
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: subjectNameController,
                  decoration: InputDecoration(
                    hintText: 'Enter Subject Name',
                    icon: Icon(Icons.book),
                    fillColor: Colors.pink[100],
                    filled: true,
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: scoreController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter Score',
                    icon: Icon(Icons.grade),
                    fillColor: Colors.pink[100],
                    filled: true,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    double? score = double.tryParse(scoreController.text);
                    if (score != null) {
                      gradeCollection.doc(gradeData.id).update({
                        'subject_name': subjectNameController.text,
                        'score': score,
                      });
                      Navigator.pop(context); // ปิดหน้า UpdateForm
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter a valid number for score')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[400], // เปลี่ยนสีปุ่มให้เป็นสีชมพู
                  ),
                  child: Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
