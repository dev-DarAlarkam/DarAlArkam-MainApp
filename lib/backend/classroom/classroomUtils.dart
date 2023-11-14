import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/classroom/classroom.dart';
import 'package:daralarkam_main_app/backend/userManagement/studentMethods.dart';
import 'package:daralarkam_main_app/backend/userManagement/teacherMethods.dart';
import 'package:flutter/material.dart';

import '../../services/utils/showSnackBar.dart';
import '../users/users.dart';


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
   final docUser = FirebaseFirestore.instance.collection('classrooms').doc(classId);
   final snapshot = await docUser.get();

   if (snapshot.exists) {
     return true;
   }
   return false;
 }

 /// Creates a new empty classroom in Firestore.
 /// This function checks if the there's a document with the same id before
 /// attempting to create a new one
 Future<void> createANewClassroom(BuildContext context, String title, String grade) async {
   //checks if the documnet doesn't exist in firestore
   if(!(await doesClassroomExistInFirestore())){

     //creating a new empty classroom
     final classroom = Classroom(
         classId: classId,
         title: title,
         grade: grade,
         teacherId: '',
         studentIds: []
     );

     final json = classroom.toJson();
     final docClass = FirebaseFirestore.instance.collection('classrooms').doc(classId);
     await docClass.set(json)
         .onError((error, stackTrace) {
           showSnackBar(context, error.toString());
         });

   }
   else {
     showSnackBar(context, "لا يمكن انشاء هذه المجموعة: المعرّف الخاص بالمجموعة تم استخدامه");
   }
 }


 /// Adds a teacher as the classroom teacher, updates the teacherId in the classroom document,
 /// and the classIds in the teacher's document.
 ///
 /// This function adds a teacher to a classroom as the teacher and ensures that the teacher is not
 /// already the teacher of the classroom. If the classroom already has a teacher, the previous
 /// teacher is removed from the classroom. It also checks if the teacher exists in Firestore
 /// before making any updates.
 Future<void> addTeacherToClass(BuildContext context, String teacherId) async {
   final Classroom? classroom = await fetchClassroomFromFirebase();

   // Check if the classroom exists in Firestore.
   if (classroom != null) {

     // Check if the teacher is already the teacher of the classroom.
     if (classroom.teacherId == teacherId) {
       showSnackBar(context, "هذا المربي هو المربي الحالي للمجموعة");
       return;
     }
     // Check if the classroom has a previous teacher and remove them.
     else if (classroom.teacherId != '') {
       removeATeacherFromTheClassroom(context, classroom.teacherId);
     }

     final Teacher? teacher = await TeacherMethods(teacherId).fetchTeacherFromFirebase();
     // Check if the teacher exists in Firestore.
     if (teacher != null) {
       final docUser =
       FirebaseFirestore.instance.collection('users').doc(teacherId);
       await docUser.update({'classIds': FieldValue.arrayUnion([classId]),})
           .then((value) {
             final docClass = FirebaseFirestore.instance.collection('classrooms').doc(classId);
             docClass.update({'teacherId': teacherId,})
                 .then((_) {
                   showSnackBar(context, "تمت إضافة المربي بنجاح");
                 }).catchError((error) {
                   showSnackBar(context, "حدث خطأ أثناء إضافة المربي: $error");
                 });
           }).catchError((error) {
             showSnackBar(context, "حدث خطأ أثناء تحديث معلومات المربي: $error");
           });
     }
     else{
       showSnackBar(context, "معلومات المربي غير موجودة");
     }
   }
   // Display a message if the classroom doesn't exist in Firestore.
   else {
     showSnackBar(context, "معلومات المجموعة غير موجودة");
   }
 }


 /// Adds a student to a class in Firestore and updates the student's class ID.
 /// This function checks if the classroom and student exist in Firestore before
 /// attempting to make any updates.
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
   final Teacher? teacher = await TeacherMethods(teacherId).fetchTeacherFromFirebase();

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
         docTeacher.update({'classIds': classIds}).onError((error, stackTrace) {
           showSnackBar(context, error.toString());
         });
       });

     }
   }
   else {
     showSnackBar(context, "معلومات المربي غير موجودة");
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
