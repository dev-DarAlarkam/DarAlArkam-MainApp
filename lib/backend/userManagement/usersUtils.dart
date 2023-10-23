import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/classroom/classroomUtils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/utils/showSnackBar.dart';
import '../users/users.dart';

Future<FirebaseUser?>  readUser(String uid) async{
  final docUser = FirebaseFirestore.instance.collection('users').doc(uid);
  final snapshot = await docUser.get();

  if(snapshot.exists) {
    return FirebaseUser.fromJson(snapshot.data()!);
  }
  return null;
}

Future<Student?>  readStudent(String uid) async{
  final docUser = FirebaseFirestore.instance.collection('users').doc(uid);
  final snapshot = await docUser.get();

  if(snapshot.exists) {
    return Student.fromJson(snapshot.data()!);
  }
  return null;
}

Future<Teacher?>  readTeacher(String uid) async{
  final docUser = FirebaseFirestore.instance.collection('users').doc(uid);
  final snapshot = await docUser.get();

  if(snapshot.exists) {
    return Teacher.fromJson(snapshot.data()!);
  }
  return null;
}

Future<bool> checkUserExist(BuildContext context, String uid) async{
  final docUser = FirebaseFirestore.instance.collection('users').doc(uid);
  final snapshot = await docUser.get();

  if(snapshot.exists) {
    return true;
  }
  return false;
}

String getUsername(FirebaseUser user) {
  if (user != null) {
    return user.firstName + " " + user.secondName + " " + user.thirdName;
  }
  return '';
}

String getCurrentUserId() {
  return FirebaseAuth.instance.currentUser!.uid;
}

Future<void> updateUser(BuildContext context, String uid, String oldType, String newType) async {
  final docUser = FirebaseFirestore.instance
      .collection('users')
      .doc(uid);

  if(oldType == 'guest' || oldType == 'admin'){
    switch (newType) {
      case "student":
        //adding the 'classid' field which is
        await docUser.update({"type": newType}).onError((error, stackTrace) {
          showSnackBar(context, error.toString());
        });
        await docUser.update({"classId": ""}).onError((error, stackTrace) {
          showSnackBar(context, error.toString());
        });
        showSnackBar(context, "تم التحويل بنجاح");
        break;

        //adding the 'classids' field
      case "teacher":
        await docUser.update({"type": newType}).onError((error, stackTrace) {
          showSnackBar(context, error.toString());
        });
        await docUser.update({"classIds": []}).onError((error, stackTrace) {
          showSnackBar(context, error.toString());
        });
        showSnackBar(context, "تم التحويل بنجاح");
        break;

      default:
        await docUser.update({"type": newType}).onError((error, stackTrace) {
          showSnackBar(context, error.toString());
        });
        showSnackBar(context, "تم التحويل بنجاح");
    }
  }
  else if(oldType == 'student') {
    switch (newType) {
      //we don't need to change it
      case "student":
        break;

      case "teacher":

        removeStudentFromClassroom(context, await getClassIdFromStudentId(uid), uid);

        await docUser.update({"type": newType}).onError((error, stackTrace) {
          showSnackBar(context, error.toString());
        });

        await docUser.update({"classIds": []}).onError((error, stackTrace) {
          showSnackBar(context, error.toString());
        });
        showSnackBar(context, "تم التحويل بنجاح");

        break;

      default:
        removeStudentFromClassroom(context, await getClassIdFromStudentId(uid), uid);
        await docUser.update({"type": newType}).onError((error, stackTrace) {
          showSnackBar(context, error.toString());
        });
        showSnackBar(context, "تم التحويل بنجاح");
    }
  }
  else if(oldType == 'teacher') {
    switch (newType) {
      case "student":
        removeTeacherFromClassrooms(context, uid);
        await docUser.update({"type": newType}).onError((error, stackTrace) {
          showSnackBar(context, error.toString());
        });
        await docUser.update({"classId": ""}).onError((error, stackTrace) {
          showSnackBar(context, error.toString());
        });
        showSnackBar(context, "تم التحويل بنجاح");
        break;

        //there's no need to change anything in this situation
      case "teacher":
        break;

      default:
        await docUser.update({"type": newType}).onError((error, stackTrace) {
          showSnackBar(context, error.toString());
        });
        removeTeacherFromClassrooms(context, uid);
        showSnackBar(context, "تم التحويل بنجاح");
    }
  }
  else {
    showSnackBar(context, "لا يمكن القيام بهذه العملية حالياً، تواصل مع المطوّر");
  }

  //exiting the tab after executing the switch
  Navigator.pop(context);

}

Future<void> deleteUser(BuildContext context, String type, String uid) async {
  switch (type) {
    case "student" :
      removeStudentFromClassroom(context, await getClassIdFromStudentId(uid), uid);
      break;

    case "teacher" :
      removeTeacherFromClassrooms(context, uid);
      break;
  }
  final docUser = FirebaseFirestore.instance
      .collection('users')
      .doc(uid);
  await docUser.delete();
  Navigator.pop(context);
}