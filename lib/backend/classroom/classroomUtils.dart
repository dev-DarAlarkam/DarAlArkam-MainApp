import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/classroom/classroom.dart';
import 'package:daralarkam_main_app/backend/userManagement/usersUtils.dart';
import 'package:flutter/material.dart';

import '../../services/utils/showSnackBar.dart';

Future<Classroom?> readClassroom(String cid) async{
  final docClass = FirebaseFirestore.instance.collection('classrooms').doc(cid);
  final snapshot = await docClass.get();

  if(snapshot.exists) {
    return Classroom.fromJson(snapshot.data()!);
  }
  return null;
}

// Function to add a student to a classroom
Future<void> addStudentToClass(BuildContext context, String classId, String studentId) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc(studentId);
  await docUser.update({"classId": classId}).then((value) {
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
    removeStudentFromClassroom(context, classId, studentId);
  });
}

Future<void> removeStudentFromClassroom(BuildContext context, String cid, String uid) async {
  final docClass = FirebaseFirestore.instance.collection('classrooms').doc(cid);
  final docUser = FirebaseFirestore.instance.collection('users').doc(uid);

  // Fetch the current list of student IDs
  docClass.get().then((classroomSnapshot) {
    if (classroomSnapshot.exists) {
      final List<dynamic> studentIds = classroomSnapshot.data()?['studentIds'];

      // Check if the student to remove exists in the list
      if (studentIds.contains(uid)) {
        studentIds.remove(uid);

        // Update the 'studentIds' field with the modified list
        docClass.update({'studentIds': studentIds}).then((_) {

          //Fetch the student data
          docUser.get().then((snapshotUser) {

            //check if the user we want to remove exists
            if(snapshotUser.exists) {

              //update the 'classId' field with ''
              docUser.update({'classId': ''})
                  .then((value) {
                showSnackBar(context, "تم إزالة الطالب بنجاح");
              })
                  .catchError((error, stackTrace) {
                showSnackBar(context, error.toString());
              });

            }
          });
        }).catchError((error) {
          showSnackBar(context, error.toString());
        });
      } else {
        print("Student not found in classroom.");
      }
    } else {
      print("Classroom not found.");
    }
  });
}

Future<String> getClassIdFromStudentId(String uid) async{
  final student = await readStudent(uid);

  if (student!= null) {
    return student.classId;
  }
  return '';
}

Future<void> removeTeacherFromClassrooms(BuildContext context, String uid) async {

  final teacher = await readTeacher(uid);

  //removing the userId from the 'teacherId' field in the classroom
  if (teacher != null ) {
    for(String cid in teacher.classIds){
      final docClass = FirebaseFirestore.instance.collection('classrooms').doc(cid);

      docClass.get().then((classSnapshot) => {
        if(classSnapshot.exists) {
          docClass.update({'teacherId':''}).onError((error, stackTrace) {
            showSnackBar(context, error.toString());
          })
        }
      });
    }
  }

}