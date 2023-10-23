import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../ui/firebase/admin/admin.dart';
import '../../../ui/firebase/guest/guest.dart';
import '../../../ui/firebase/new-user/new-user.dart';
import '../../../ui/firebase/student/student.dart';
import '../../../ui/firebase/teacher/teacher.dart';

void navigateBasedOnType(BuildContext context, String uid) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) {
      return FutureBuilder(
        future: getUserType(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final String userType = snapshot.data.toString();

            switch (userType) {
              case "guest":
                return const GuestTab();
              case "student":
                return const StudentTab();
              case "teacher":
                return const TeacherTab();
              case "admin":
                return const AdminTab();
              default:
                return const NewUserTab();
            }
          }
        },
      );
    },),
          (route) => route.isFirst).onError((error, stackTrace) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("$error")));}
  );
}

Future<String> getUserType(String uid) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc(uid);
  final snapshot = await docUser.get();

  if (snapshot.exists) {
    return snapshot.data()?['type'];
  } else {
    return "new"; // Or any other default value
  }
}


