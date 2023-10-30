import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../services/utils/showSnackBar.dart';
import '../classroom/classroomUtils.dart';
import '../users/users.dart';
import 'firebaseUserMethods.dart';

// Class for teacher-specific methods, inherits from FirebaseUserMethods.
class TeacherMethods extends FirebaseUserMethods {
  TeacherMethods(String userId) : super(userId);

  // Fetches teacher information from Firestore.
  Future<Teacher?> fetchTeacherFromFirebase() async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(userId);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return Teacher.fromJson(snapshot.data()!);
    }
    return null;
  }


  // Removes a teacher from their assigned classrooms.
  // This function retrieves information about the teacher and their assigned classrooms,
  // and then proceeds to remove the teacher from each classroom.
  Future<void> removeTeacherFromHisClassrooms(BuildContext context) async {
    // Retrieve teacher information from Firestore.
    final teacher = await TeacherMethods(userId).fetchTeacherFromFirebase();
    final docTeacher = FirebaseFirestore.instance.collection('users').doc(userId);

    // Check if the teacher information is available.
    if (teacher != null) {
      // Loop through the teacher's assigned class IDs.
      for (String cid in teacher.classIds) {
        ClassroomMethods(cid).removeATeacherFromTheClassroom(context, userId);
      }

      // Update the teacher's classIds field to an empty list.
      docTeacher.update({'classIds': []}).onError((error, stackTrace) {
        showSnackBar(context, error.toString());
      });
    }
  }

  // Overrides the deleteUser method to include teacher-specific logic.
  @override
  Future<void> deleteUser(BuildContext context) async {
    removeTeacherFromHisClassrooms(context);
    super.deleteUser(context);
  }


}
