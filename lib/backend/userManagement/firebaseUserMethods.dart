import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/counter/getCounter.dart';
import 'package:daralarkam_main_app/backend/userManagement/additionalInformationMethods.dart';
import 'package:daralarkam_main_app/backend/userManagement/studentMethods.dart';
import 'package:daralarkam_main_app/backend/userManagement/teacherMethods.dart';
import 'package:flutter/cupertino.dart';

import '../../services/utils/showSnackBar.dart';
import '../users/firebaseUser.dart';


// Class to encapsulate Firebase user-related methods.
class FirebaseUserMethods {
  final String userId;

  FirebaseUserMethods(this.userId);

  /// Uploads user information to firestore, but first checks the if
  /// the information is valid and not empty
  Future<void> uploadUserToFirestore(BuildContext context, FirebaseUser user) async {

    if( user.firstName.isNotEmpty
        && user.fatherName.isNotEmpty
        && user.grandfatherName.isNotEmpty
        && user.familyName.isNotEmpty
        //checks if the birthday is valid
        //todo: check if the user is 13 years old
        && user.birthday != getFormattedDate() ) {

      final json = user.toJson();
      final docUser = FirebaseFirestore.instance
          .collection('users')
          .doc(userId);

      await docUser.set(json).onError((error, stackTrace) {
        showSnackBar(context, error.toString());
      });

    }
    else {
      showSnackBar(context, "المعلومات غير كافية");
    }


  }


  // Fetches user information from Firestore.
  Future<FirebaseUser?> fetchUserFromFirestore() async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(userId);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return FirebaseUser.fromJson(snapshot.data()!);
    }
    return null;
  }

  // Checks if a user with the given UID exists in Firestore.
  Future<bool> doesUserExistInFirestore() async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(userId);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return true;
    }
    return false;
  }


  // Retrieves the user's type.
  Future<String> getType() async {
    final user = await fetchUserFromFirestore();

    if (user != null) {
      return user.type;
    }
    return 'new';
  }

  /// Converts a user to a guest role in Firestore.
  ///
  /// This function checks if the user exists in Firestore and then converts the user's role to "guest".
  /// Depending on the user's current role, it may also perform additional actions like
  /// removing them from their existing classrooms (for students and teachers).
  Future<void> castToGuest(BuildContext context) async {
    // Check if the user exists in Firestore.
    final FirebaseUser? user = await fetchUserFromFirestore();
    if (user != null) {
      final docUser =
          FirebaseFirestore.instance.collection('users').doc(userId);
      final currentType = user.type;

      if (currentType != '') {
        switch (currentType) {
          case "guest":
            return; // If the user is already an admin, no action is required.

          case "student":
            // For students, remove them from their classroom before converting to admin.
            await StudentMethods(userId).removeStudentFromHisClassroom(context);
            break;

          case 'teacher':
            // For teachers, remove them from their classrooms before converting to admin.
            await TeacherMethods(userId)
                .removeTeacherFromHisClassrooms(context);
            break;

          default:
        }
      }
      // Update the user's role to "guest" after necessary actions.
      await docUser.update({"type": "guest"}).then((value) {
        showSnackBar(context, "تم التحويل بنجاح");
      }).catchError((error, stackTrace) {
        showSnackBar(context, error.toString());
      });
    }
    else {
      showSnackBar(context, "معلومات المستخدم غير متوفرة");
    }
  }

  /// Converts a user to an guest role in Firestore.
  ///
  /// This function checks if the user exists in Firestore and then converts the user's role to "guest".
  /// Depending on the user's current role, it may also perform additional actions like
  /// removing them from their existing classrooms (for students and teachers).
  Future<void> castToAdmin(BuildContext context) async {
    // Check if the user exists in Firestore.
    if (await doesUserExistInFirestore()) {
      final docUser =
          FirebaseFirestore.instance.collection('users').doc(userId);
      final currentType = await getType();

      if (await doesUserExistInFirestore()) {
        if (currentType != '') {
          switch (currentType) {
            case "admin":
              return; // If the user is already an admin, no action is required.

            case "student":
              // For students, remove them from their classroom before converting to admin.
              await StudentMethods(userId)
                  .removeStudentFromHisClassroom(context);
              break;

            case 'teacher':
              // For teachers, remove them from their classrooms before converting to admin.
              await TeacherMethods(userId)
                  .removeTeacherFromHisClassrooms(context);
              break;

            default:
              break;
          }

          // Update the user's role to "admin" after necessary actions.
          await docUser.update({"type": "admin"}).then((value) {
            showSnackBar(context, "تم التحويل بنجاح");
          }).catchError((error, stackTrace) {
            showSnackBar(context, error.toString());
          });
        }
      }
    }
  }

  /// Converts a user to an student role in Firestore.
  ///
  /// This function checks if the user exists in Firestore and then converts the user's role to "student".
  /// Depending on the user's current role, it may also perform additional actions like
  /// removing them from their existing classrooms (teachers),
  /// and adding a 'classId' field.
  Future<void> castToStudent(BuildContext context) async {
    // Check if the user exists in Firestore.
    if (await doesUserExistInFirestore()) {
      final docUser =
          FirebaseFirestore.instance.collection('users').doc(userId);
      final currentType = await getType();

      if (await doesUserExistInFirestore()) {
        if (currentType != '') {
          switch (currentType) {
            case "student":
              return; // If the user is already an admin, no action is required.

            case 'teacher':
              // For teachers, remove them from their classrooms before converting to admin.
              await TeacherMethods(userId)
                  .removeTeacherFromHisClassrooms(context);
              break;

            default:
              break;
          }

          // Add an empty 'classId' field to the user's document in Firebase
          await docUser.update({"classId": ""}).onError((error, stackTrace) {
            showSnackBar(context, error.toString());
          });

          // Update the user's role to "admin" after necessary actions.
          await docUser.update({"type": "student"}).then((value) {
            showSnackBar(context, "تم التحويل بنجاح");
          }).catchError((error, stackTrace) {
            showSnackBar(context, error.toString());
          });
        }
      }
    }
  }

  /// Converts a user to a teacher role in Firestore.
  ///
  /// This function checks if the user exists in Firestore and then converts the user's role to "teacher".
  /// Depending on the user's current role, it may also perform additional actions like
  /// removing them from their existing classrooms (for students),
  /// and adding a 'classIds' field with an empty list.
  Future<void> castToTeacher(BuildContext context) async {
    // Check if the user exists in Firestore.
    if (await doesUserExistInFirestore()) {
      final docUser =
          FirebaseFirestore.instance.collection('users').doc(userId);
      final currentType = await getType();

      if (await doesUserExistInFirestore()) {
        if (currentType != '') {
          switch (currentType) {
            case "teacher":
              return; // If the user is already an admin, no action is required.

            case "student":
              // For students, remove them from their classroom before converting to admin.
              await StudentMethods(userId)
                  .removeStudentFromHisClassroom(context);
              break;

            default:
              break;
          }

          // Add an empty 'classIds' field to the user's document in Firebase
          await docUser.update({"classIds": []}).onError((error, stackTrace) {
            showSnackBar(context, error.toString());
          });

          // Update the user's role to "admin" after necessary actions.
          await docUser.update({"type": "teacher"}).then((value) {
            showSnackBar(context, "تم التحويل بنجاح");
          }).catchError((error, stackTrace) {
            showSnackBar(context, error.toString());
          });
        }
      }
    }
  }

  // Deletes the user from Firestore, but first it converts the user type to guest
  // and deletes the additional information of the user
  Future<void> deleteUser(BuildContext context) async {
    castToGuest(context);
    AdditionalInformationMethods(userId).deleteInfo();

    final docUser = FirebaseFirestore.instance.collection('users').doc(userId);
    await docUser.delete();
    Navigator.pop(context);
  }
}
