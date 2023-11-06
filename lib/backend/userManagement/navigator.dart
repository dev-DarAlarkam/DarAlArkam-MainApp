import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/ui/inactiveFeature.dart';
import 'package:flutter/material.dart';
import '../../../ui/firebase/users/admin/admin.dart';
import '../../../ui/firebase/users/guest/guest.dart';
import '../../../ui/firebase/users/new-user/new-user.dart';
import '../../../ui/firebase/users/student/student.dart';
import '../../../ui/firebase/users/teacher/teacher.dart';

void navigateBasedOnType(BuildContext context, String uid) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) {
      return FutureBuilder(
        future: getUserType(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                appBar: AppBar(iconTheme: const IconThemeData(color: Colors.white,),),
                body: const Center(child: CircularProgressIndicator())
              ),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(iconTheme: const IconThemeData(color: Colors.white,),),
              body:  Center(child: Text("Error: ${snapshot.error}")));
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
              case "new":
                return const NewUserTab();
              default :
                return const InactiveFeatureTab();
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


