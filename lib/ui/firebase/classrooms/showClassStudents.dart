import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/classroom/classroomUtils.dart';
import 'package:daralarkam_main_app/backend/users/users.dart';
import 'package:daralarkam_main_app/ui/firebase/classrooms/showStudentDetails.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/material.dart';
import '../../../../services/utils/showSnackBar.dart';

// Enum to determine the sort order for students' list
enum SortOrder { ascending, descending }

class ShowClassStudentsTab extends StatefulWidget {
  const ShowClassStudentsTab({Key? key,required this.classId}) : super(key: key);
  final classId;

  @override
  State<ShowClassStudentsTab> createState() => _ShowClassStudentsTabState();
}

class _ShowClassStudentsTabState extends State<ShowClassStudentsTab> {
  // Keeps track of the current sort order (ascending by default)
  SortOrder _currentSortOrder = SortOrder.ascending;
  // List to store students data
  List<Student> students = [];

  // Stream to read students who are not in any classroom
  Stream<List<FirebaseUser>> readStudentsInsideAClassroom(String classId) =>
      FirebaseFirestore.instance
          .collection('users')
          .where('type', isEqualTo: 'student')
          .where('classId', isEqualTo: classId)
          .snapshots()
          .map((event) => event.docs.map((e) => Student.fromJson(e.data())).toList());

  // Function to sort students based on their first names
  void sortStudents(SortOrder order) {
      if (order == SortOrder.ascending) {
        students.sort((a, b) => a.firstName.compareTo(b.firstName));
      } else {
        students.sort((a, b) => b.firstName.compareTo(a.firstName));
      }
  }
  @override
  void initState() {
    super.initState();
    // Fetch and sort the counters when the widget is initialized
    sortStudents(_currentSortOrder);
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("الطلاب"),
          actions: [
            // Sort button in the app bar
            IconButton(
              icon: Icon(Icons.sort),
              onPressed: () {
                // Toggle the sort order and update the list
                final newOrder = _currentSortOrder == SortOrder.ascending
                    ? SortOrder.descending
                    : SortOrder.ascending;
                sortStudents(newOrder);
                setState(() {
                  _currentSortOrder = newOrder;
                });
              },
            )
          ],
        ),
        body: Center(
          child: StreamBuilder(
            stream: readStudentsInsideAClassroom(widget.classId),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else if (snapshot.hasData) {
                students = snapshot.data as List<Student>;
                sortStudents(_currentSortOrder);
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

  // Build a list tile for a student
  Widget buildStudent(Student student) => ListTile(
    title: Text(student.firstName + " " + student.secondName + " " + student.thirdName),
    subtitle: Text(student.birthday),
    trailing: ElevatedButton(
      onPressed: () {
        removeStudentFromClassroom(context,widget.classId, student.id);
        // setState(() {});
      },
      child: coloredArabicText("حذف",c: Colors.white),
    ),
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> ShowStudentDetailsTab(uid:student.id)));
    },
  );
}
