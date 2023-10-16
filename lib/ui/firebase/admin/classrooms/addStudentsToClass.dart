import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/users/users.dart';
import 'package:daralarkam_main_app/ui/firebase/admin/user-profile.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/material.dart';

import '../../../../services/utils/showSnackBar.dart';

class AddStudentsToClassroomTab extends StatefulWidget {
  const AddStudentsToClassroomTab({Key? key, this.classId}) : super(key: key);
  final classId;
  @override
  State<AddStudentsToClassroomTab> createState() => _AddStudentsToClassroomTabState();
}

class _AddStudentsToClassroomTabState extends State<AddStudentsToClassroomTab> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text("Users"),),
        body: Center(
          child: StreamBuilder(
            // Stream of students outside a classroom
            stream: readStudentsOutsideAClassroom(widget.classId),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else if (snapshot.hasData) {
                final List<Student> students = snapshot.data as List<Student>;
                return Center(
                  child: ListView(
                    children: students.map(buildStudent).toList(),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }

  // Stream to read students outside a classroom with specific filters
  Stream<List<FirebaseUser>> readStudentsOutsideAClassroom(String classId) => FirebaseFirestore.instance
      .collection('classrooms')
      .where('type', isEqualTo: 'student')
      .where('classId', isEqualTo: "") // Add your filtering condition here
      .snapshots()
      .map((event) => event.docs
      .map((e) => Student.fromJson(e.data()))
      .toList());

  // Widget to build a student list item
  Widget buildStudent(Student student) => ListTile(
    title: Text(student.firstName + " " + student.secondName + " " + student.thirdName),
    subtitle: Text(student.birthday),
    trailing: ElevatedButton(
      onPressed: () {
        // Function to add a student to a class
        addStudentToClass(widget.classId, student.id);
        setState(() {});
      },
      child: coloredArabicText("أضف"),
    ),
  );

  // Function to add a student to a class
  Future<void> addStudentToClass(String classId, String studentId) async {
    // Update the student document to set the class ID
    final docUser = FirebaseFirestore.instance.collection('users').doc(studentId);
    await docUser.update({"classId": classId}).then((value) {
      // After successfully updating the student document, update the class document
      final docClass = FirebaseFirestore.instance.collection('classrooms').doc(classId);
      docClass.update({
        'studentIds': FieldValue.arrayUnion([studentId]),
      }).then((_) {
        showSnackBar(context, "تمت إضافة الطالب بنجاح");
      }).catchError((error) {
        showSnackBar(context, "حدث خطأ أثناء إضافة الطالب: $error");
      });
    }).catchError((error) {
      showSnackBar(context, "حدث خطأ أثناء تحديث معلومات الطالب: $error");
    });
  }
}
