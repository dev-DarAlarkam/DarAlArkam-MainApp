import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/ui/inactiveFeature.dart';
import 'package:flutter/material.dart';
import 'package:daralarkam_main_app/backend/userManagement/firebaseUserMethods.dart';

import '../../../ui/firebase/users/admin/admin.dart';
import '../../../ui/firebase/users/guest/guest.dart';
import '../../../ui/firebase/users/new-user/new-user.dart';
import '../../../ui/firebase/users/student/student.dart';
import '../../../ui/firebase/users/teacher/teacher.dart';

/// Navigates to a specific tab based on the user type and removes previous routes from the navigation stack.
///
/// This function uses [Navigator.pushAndRemoveUntil] to navigate to a new screen based on the user type retrieved
/// from the [FirebaseUserMethods(uid).getUserType()] Future. It supports various user types, including "guest," "student," "teacher," "admin," "new," and others.
///
/// - [context]: The [BuildContext] of the current widget.
/// - [uid]: The unique identifier of the user.
///
/// Returns `void`.
void navigateBasedOnType(BuildContext context, String uid) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) {
      return FutureBuilder(
        future: FirebaseUserMethods(uid).getType(),
        builder: (context, snapshot) {
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                appBar: AppBar(iconTheme: const IconThemeData(color: Colors.white,),),
                body: const Center(child: CircularProgressIndicator())
              ),
            );
          } 
          
          else if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(iconTheme: const IconThemeData(color: Colors.white,),),
              body:  Center(child: Text("Error: ${snapshot.error}")));
          } 
          
          else {
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
          .showSnackBar(SnackBar(content: Text("$error")));
    }
  );
}



