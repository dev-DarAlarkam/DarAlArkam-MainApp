import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/classroom/classroom.dart';
import 'package:daralarkam_main_app/backend/userManagement/firebaseUserMethods.dart';
import 'package:daralarkam_main_app/backend/userManagement/firebaseUserUtils.dart';
import 'package:daralarkam_main_app/backend/userManagement/studentMethods.dart';
import 'package:daralarkam_main_app/backend/userManagement/teacherMethods.dart';
import 'package:flutter/material.dart';

import '../../services/utils/showSnackBar.dart';


class ClassroomMethods {
 final String classId;
 ClassroomMethods(this.classId);

 // Fetches classroom information from Firestore.
 Future<Classroom?> fetchClassroomFromFirebase() async{
   final docClass = FirebaseFirestore.instance.collection('classrooms').doc(classId);
   final snapshot = await docClass.get();

   if(snapshot.exists) {
     return Classroom.fromJson(snapshot.data()!);
   }
   return null;
 }

 Future<bool> doesClassroomExistInFirestore() async {
   final docUser = FirebaseFirestore.instance.collection('users').doc(classId);
   final snapshot = await docUser.get();

   if (snapshot.exists) {
     return true;
   }
   return false;
 }

 // Adds a student to a class in Firestore and updates the student's class ID.
 // This function checks if the classroom and student exist in Firestore before
 // attempting to make any updates.
 Future<void> addStudentToClass(BuildContext context, String studentId) async {
   // Check if the classroom and student exist in Firestore.
   if (await doesClassroomExistInFirestore() && await StudentMethods(studentId).doesUserExistInFirestore()) {
     final docUser = FirebaseFirestore.instance.collection('users').doc(studentId);
     final docClass = FirebaseFirestore.instance.collection('classrooms').doc(classId);

     // Update the student's class ID in Firestore.
     await docUser.update({"classId": classId}).then((value) {
       // Update the classroom's student list with the new student.
       docClass.update({
         'studentIds': FieldValue.arrayUnion([studentId]),
       }).then((_) {
         showSnackBar(context, "تمت إضافة الطالب بنجاح");
       }).catchError((error) {
         showSnackBar(context, "حدث خطأ أثناء إضافة الطالب: $error");
       });
     }).catchError((error) {
       showSnackBar(context, "حدث خطأ أثناء تحديث معلومات الطالب: $error");
       removeStudentFromClassroom(context, studentId);
     });
   } else {
     showSnackBar(context, "معلومات الطالب أو المجموعة التربوية غير متوفرة");
   }
 }

  //Function to remove a Student from a Classroom
  Future<void> removeStudentFromClassroom(BuildContext context, String studentId) async {
    final docClass = FirebaseFirestore.instance.collection('classrooms').doc(classId);
    final docUser = FirebaseFirestore.instance.collection('users').doc(studentId);

    // Fetch the current list of student IDs
    docClass.get().then((classroomSnapshot) {
      if (classroomSnapshot.exists) {
        final List<dynamic> studentIds = classroomSnapshot.data()?['studentIds'];

        // Check if the student to remove exists in the list
        if (studentIds.contains(studentId)) {
          studentIds.remove(studentId);

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

 //Function to remove a teacher from the specified Classroom
 Future<void> removeATeacherFromTheClassroom(BuildContext context, String teacherId) async {
   final teacher = await TeacherMethods(teacherId).fetchTeacherFromFirebase();

   if (teacher != null ) {
     //check if the if the teacher is actually the teacher of the class
     if (teacher.classIds.contains(classId)){
       final docClass = FirebaseFirestore.instance.collection('classrooms').doc(classId);

       //remove the teacher from the classroom
       docClass.get().then((classSnapshot) => {
         if(classSnapshot.exists) {
           docClass.update({'teacherId':''}).onError((error, stackTrace) {
             showSnackBar(context, error.toString());
           })
         }
       });

       //remove the class id from the teacher's profile
       final classIds = teacher.classIds;
       classIds.remove(classId);

       final docTeacher = FirebaseFirestore.instance.collection('users').doc(teacherId);

       docTeacher.get().then((teacherSnapshot) {
         if(teacherSnapshot.exists){
           docTeacher.update({'classIds': classIds}).onError((error, stackTrace) {
             showSnackBar(context, error.toString());
           });
         }
       });

     }
   }
 }


 // Function to delete a Classroom
 Future<void> deleteAClassroom(BuildContext context) async{

   final Classroom? classroom = await fetchClassroomFromFirebase();

   if(classroom != null) {
     //removing the students in the classroom
     for(String studentId in classroom.studentIds){
       removeStudentFromClassroom(context, studentId);
     }

     //removing the teacher
     removeATeacherFromTheClassroom(context,classroom.teacherId);

     //deleting the document
     final docClass = FirebaseFirestore.instance.collection('classrooms').doc(classroom.classId);
     docClass.delete().onError((error, stackTrace) {showSnackBar(context, error.toString());});
   }
 }

}
