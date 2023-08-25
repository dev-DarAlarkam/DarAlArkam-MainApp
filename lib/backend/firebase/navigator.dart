import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../services/utils/showSnackBar.dart';
import '../../ui/Authenticate/authenticationTab.dart';
import '../../ui/firebase/admin/admin.dart';
import '../../ui/firebase/guest/guest.dart';
import '../../ui/firebase/new-user/new-user.dart';
import '../../ui/firebase/student/student.dart';
import '../../ui/firebase/teacher/teacher.dart';

void navigateBasedOnType(BuildContext context, String uid) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc(uid);
  final snapshot = await docUser.get();

  if(snapshot.exists) {
    switch (snapshot.data()?['type']){
      case "guest":
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const GuestTab()),
                (route) => route.isFirst).onError((error, stackTrace) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("$error")));
        });
        return;
      case "student":
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const StudentTab()),
                (route) => route.isFirst).onError((error, stackTrace) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("$error")));
        });
        return;
      case "teacher":
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const TeacherTab()),
                (route) => route.isFirst).onError((error, stackTrace) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("$error")));
        });
        return;
      case "admin":
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AdminTab()),
                (route) => route.isFirst).onError((error, stackTrace) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("$error")));
        });
        return;
      default :
        showSnackBar(context, "Try again later");
        return;
    }
  }

  Navigator.push(context, MaterialPageRoute(builder: (context) => const NewUserTab()));

}