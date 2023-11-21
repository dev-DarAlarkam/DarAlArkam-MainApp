import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/classroom/classroomUtils.dart';
import 'package:daralarkam_main_app/backend/users/supervisor.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/material.dart';

import '../../../../../backend/users/firebaseUser.dart';
import '../../../../../backend/users/teacher.dart';

// Enum to determine the sort order for the list of teachers
enum SortOrder { ascending, descending }

class SelectATeacherTab extends StatefulWidget {
  const SelectATeacherTab({Key? key, required this.classId}) : super(key: key);
  final String classId;

  @override
  State<SelectATeacherTab> createState() => _SelectATeacherTabState();
}

class _SelectATeacherTabState extends State<SelectATeacherTab> {
  // Keeps track of the current sort order (ascending by default)
  SortOrder _currentSortOrder = SortOrder.ascending;
  // List to store teacher data
  List<Teacher> teachers = [];

  // Stream to read teachers who are not assigned to any classroom
  Stream<List<FirebaseUser>> readTeachers() =>
      FirebaseFirestore.instance
          .collection('users')
          .where('type', isEqualTo: 'teacher')
          .snapshots()
          .map((event) => event.docs.map((e) => Teacher.fromJson(e.data())).toList());

  // Function to sort teachers based on their first names
  void sortTeachers(SortOrder order) {
    if (order == SortOrder.ascending) {
      teachers.sort((a, b) => a.fullName.compareTo(b.fullName));
    } else {
      teachers.sort((a, b) => b.fullName.compareTo(a.fullName));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: boldColoredArabicText("إختر مربي للمجموعة", c: Colors.white),
          actions: [
            // Sort button in the app bar
            IconButton(
              icon: Icon(Icons.sort),
              onPressed: () {
                // Toggle the sort order and update the list
                final newOrder = _currentSortOrder == SortOrder.ascending
                    ? SortOrder.descending
                    : SortOrder.ascending;
                sortTeachers(newOrder);
                setState(() {
                  _currentSortOrder = newOrder;
                });
              },
            )
          ],
        ),
        body: Center(
          child: StreamBuilder(
            stream: readTeachers(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                teachers = snapshot.data as List<Teacher>;
                sortTeachers(_currentSortOrder);
                return Center(
                  child: ListView(
                    children: teachers.map(buildTeacher).toList(),
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

  // Build a list tile for a teacher
  Widget buildTeacher(Teacher teacher) => ListTile(
    title: Text(teacher.fullName),
    subtitle: Text(teacher.birthday),
    trailing: ElevatedButton(
      onPressed: () {
        _showChangeConfirmationDialog(context,widget.classId, teacher.id)
            .then((value) {
          Navigator.pop(context);
        });
      },
      child: coloredArabicText("اختر", c: Colors.white),
    ),
  );

  Future<void> _showChangeConfirmationDialog(BuildContext context, String classId, String teacherId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Dialog cannot be dismissed by tapping outside
      builder: (BuildContext dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('تأكيد التغيير'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('هل تريد حقًا تغيير مربي هذه المجموعة؟'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('إلغاء'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
              TextButton(
                child: Text('تغيير'),
                onPressed: () {
                  ClassroomMethods(classId).addTeacherToClass(context, teacherId);
                  Navigator.of(dialogContext).pop(); // Close the dialog
                },
              ),
            ],
          ),
        );
      },
    );
  }

}
