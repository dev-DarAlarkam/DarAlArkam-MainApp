import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../services/utils/showSnackBar.dart';
import '../classroom/classroomUtils.dart';
import '../users/users.dart';
import 'firebaseUserMethods.dart';


// Class for student-specific methods, inherits from FirebaseUserMethods.
class StudentMethods extends FirebaseUserMethods {
  StudentMethods(String userId) : super(userId);

  // Fetches student information from Firestore.
  Future<Student?> fetchStudentFromFirestore() async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(userId);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return Student.fromJson(snapshot.data()!);
    }
    return null;
  }

  // Retrieves the class ID of a student.
  Future<String> getClassId() async {
    final student = await fetchStudentFromFirestore();

    if (student != null) {
      return student.classId;
    }

    return "";
  }

  //Function to remove a Student from a Classroom
  Future<void> removeStudentFromHisClassroom(BuildContext context) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(userId);
    if(await doesUserExistInFirestore()) {
      final classId = await getClassId();
      final docClass = FirebaseFirestore.instance.collection('classrooms').doc(classId);

      docClass.get().then((classroomSnapshot) {
        if (classroomSnapshot.exists) {
          final List<dynamic> studentIds = classroomSnapshot.data()?['studentIds'];

          // Check if the student to remove exists in the list
          if (studentIds.contains(userId)) {
            studentIds.remove(userId);

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
  }

  // Overrides the deleteUser method to include student-specific logic.
  @override
  Future<void> deleteUser(BuildContext context) async {
    ClassroomMethods(await getClassId()).removeStudentFromClassroom(context, userId);
    super.deleteUser(context);
  }
}