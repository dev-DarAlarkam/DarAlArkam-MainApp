import 'package:daralarkam_main_app/backend/userManagement/firebaseUserMethods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Translates user types from one language to another.
String translateUserTypes(String type) {
  switch (type) {
    case "guest":
      return "ضيف"; // Translates "guest" to Arabic.
    case "student":
      return "طالب"; // Translates "student" to Arabic.
    case "teacher":
      return "مربي"; // Translates "teacher" to Arabic.
    case "admin":
      return "مشرف عام"; // Translates "admin" to Arabic.
    default:
      return ""; // Returns an empty string for unknown types.
  }
}

// Retrieves the current user's ID from Firebase Authentication.
String getCurrentUserId() {
  return FirebaseAuth.instance.currentUser!.uid;
}


/// Updates a user's role in Firestore.
///
/// This function allows changing a user's role to one of the specified roles:
/// "admin," "guest," "student," or "teacher." Depending on the new role, it calls the
/// appropriate method to perform the role change and then exits the current tab.
///
/// - [context]: The current [BuildContext] used for displaying snackbar messages and tab navigation.
/// - [uid]: The unique identifier of the user whose role is being updated.
/// - [newType]: The new role to assign to the user.
Future<void> updateUser(BuildContext context, String uid, String newType) async {
  // Use a switch statement to determine the new role and call the corresponding method.
  switch (newType) {
    case 'admin':
      FirebaseUserMethods(uid).castToAdmin(context);
      break;

    case 'guest':
      FirebaseUserMethods(uid).castToGuest(context);
      break;

    case 'student':
      FirebaseUserMethods(uid).castToStudent(context);
      break;

    case 'teacher':
      FirebaseUserMethods(uid).castToTeacher(context);
      break;

    default:
      break; // No action needed for an unknown role.
  }

  // Exit the current tab after executing the role change.
  Navigator.pop(context);
}
