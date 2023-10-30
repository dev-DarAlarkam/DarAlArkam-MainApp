import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/classroom/classroom.dart';
import 'package:daralarkam_main_app/backend/classroom/classroomUtils.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/material.dart';

import 'classroomProfileForAdmin.dart';

// A Flutter widget for displaying a list of classrooms for an admin.
class ClassroomsTabForAdmin extends StatefulWidget {
  const ClassroomsTabForAdmin({Key? key}) : super(key: key);

  @override
  State<ClassroomsTabForAdmin> createState() => _ClassroomsTabForAdminState();
}

class _ClassroomsTabForAdminState extends State<ClassroomsTabForAdmin> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: boldColoredArabicText("المجموعات", c: Colors.white),
        ),
        body: Center(
          child: StreamBuilder(
            stream: readClassrooms(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else if (snapshot.hasData) {
                final List<Classroom> classrooms = snapshot.data as List<Classroom>;
                return Center(
                  child: ListView(
                    children: classrooms.map(buildClassroom).toList(),
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

  // A function to read and stream a list of classrooms from Firestore.
  Stream<List<Classroom>> readClassrooms() => FirebaseFirestore.instance
      .collection('classrooms')
      .snapshots()
      .map((event) => event.docs.map((e) => Classroom.fromJson(e.data())).toList());

  // A function to build a list tile for a classroom.
  Widget buildClassroom(Classroom classroom) => ListTile(
    title: Text(classroom.title),
    subtitle: Text("الصف ${classroom.grade}"),
    onTap: () {
      // Navigate to the classroom profile page for admins.
      Navigator.push(context, MaterialPageRoute(builder: (context) => ClassroomProfileForAdminTab(cid: classroom.classId)));
    },
    trailing: ElevatedButton(
        onPressed: (){
          _showDeleteConfirmationDialog(context, classroom.classId);
        },
        child: coloredArabicText("حذف", c:Colors.white)
    ),
  );
}


Future<void> _showDeleteConfirmationDialog(BuildContext context, String classroomId) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // Dialog cannot be dismissed by tapping outside
    builder: (BuildContext dialogContext) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('تأكيد الحذف'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('هل تريد حقًا حذف هذه المجموعة؟'),
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
              child: Text('حذف'),
              onPressed: () {
                ClassroomMethods(classroomId).deleteAClassroom(context);
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
            ),
          ],
        ),
      );
    },
  );
}
