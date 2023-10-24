import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/users/users.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/material.dart';
import '../../../../../services/utils/showSnackBar.dart';

// Enum to determine the sort order for students' list
enum SortOrder { ascending, descending }

class SelectATeacherTab extends StatefulWidget {
  const SelectATeacherTab({Key? key,required this.classId}) : super(key: key);
  final String classId;

  @override
  State<SelectATeacherTab> createState() => _SelectATeacherTabState();
}

class _SelectATeacherTabState extends State<SelectATeacherTab> {
  // Keeps track of the current sort order (ascending by default)
  SortOrder _currentSortOrder = SortOrder.ascending;
  // List to store students data
  List<Teacher> teachers = [];

  // Stream to read students who are not in any classroom
  Stream<List<FirebaseUser>> readTeachers() =>
      FirebaseFirestore.instance
          .collection('users')
          .where('type', isEqualTo: 'teacher')
          .snapshots()
          .map((event) => event.docs.map((e) => Teacher.fromJson(e.data())).toList());

  // Function to sort teachers based on their first names
  void sortTeachers(SortOrder order) {
    if (order == SortOrder.ascending) {
      teachers.sort((a, b) => a.firstName.compareTo(b.firstName));
    } else {
      teachers.sort((a, b) => b.firstName.compareTo(a.firstName));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: boldColoredArabicText("إختر مربي للمجموعة", c:Colors.white),
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

  // Build a list tile for a student
  Widget buildTeacher(Teacher teacher) => ListTile(
        title: Text(teacher.firstName +
            " " +
            teacher.secondName +
            " " +
            teacher.thirdName),
        subtitle: Text(teacher.birthday),
        trailing: ElevatedButton(
          onPressed: () {
            addTeacherToClass(widget.classId, teacher.id).then((value) {
              Navigator.pop(context);
            });
          },
          child: coloredArabicText("اختر", c: Colors.white),
        ),
      );

  // Function to add a student to a classroom
  Future<void> addTeacherToClass(String classId, String teacherId) async {
    final docUser =
        FirebaseFirestore.instance.collection('users').doc(teacherId);
    await docUser.update({
      'classIds': FieldValue.arrayUnion([classId]),
    }).then((value) {
      final docClass =
          FirebaseFirestore.instance.collection('classrooms').doc(classId);
      docClass.update({
        'teacherId': teacherId,
      }).then((_) {
        showSnackBar(context, "تمت إضافة المربي بنجاح");
      }).catchError((error) {
        showSnackBar(context, "حدث خطأ أثناء إضافة المربي: $error");
      });
    }).catchError((error) {
      showSnackBar(context, "حدث خطأ أثناء تحديث معلومات المربي: $error");
    });
  }
}
