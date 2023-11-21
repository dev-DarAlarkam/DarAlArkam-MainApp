import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/userManagement/firebaseUserMethods.dart';
import 'package:flutter/material.dart';
import 'package:daralarkam_main_app/globals/globalColors.dart' as colors;

import '../../../backend/userManagement/firebaseUserUtils.dart';
import '../../widgets/text.dart';

/// Creates an elevated button for changing the user type.
///
/// This function returns an [ElevatedButton] with a specified [title] that, when pressed,
/// invokes the [updateUser] function to change the user type.
///
/// - [context]: The [BuildContext] of the current widget.
/// - [uid]: The unique identifier of the user for whom the type will be changed.
/// - [newType]: The new user type to assign.
/// - [title]: The title to display on the button.
///
/// Returns an [ElevatedButton] widget.
Widget userTypeChangeButton(BuildContext context, String uid, String newType, String title){
  final double height = MediaQuery.of(context).size.height;
  final double width = MediaQuery.of(context).size.width;
  return ElevatedButton(
    onPressed: () async {updateUser(context, uid, newType);},
    child: Container(
      height: height*0.1,
      width: width*0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.circular(10),
      ),
      child: Center(child: coloredArabicText(title, c: Colors.white)),
    ),
  );
}

/// Creates an elevated button for deleting a user.
///
/// This function returns an [ElevatedButton] with the title "احذف المستخدم" that, when pressed,
/// triggers the display of a delete confirmation dialog through [_showDeleteConfirmationDialog].
///
/// - [context]: The [BuildContext] of the current widget.
/// - [uid]: The unique identifier of the user to be deleted.
/// - [type]: The current user type.
///
/// Returns an [ElevatedButton] widget.
Widget deleteUserButton(BuildContext context, String uid, String type){
  final double height = MediaQuery.of(context).size.height;
  final double width = MediaQuery.of(context).size.width;
  return ElevatedButton(
    onPressed: () async {
      _showDeleteConfirmationDialog(context, type, uid);
    },
    child: Container(
      height: height*0.1,
      width: width*0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.circular(10),
      ),
      child: Center(child: coloredArabicText("احذف المستخدم", c: Colors.white)),
    ),
  );
}


/// Displays a delete confirmation dialog for a user.
///
/// This function shows an [AlertDialog] with a confirmation message.
/// If the user chooses to delete, it invokes the [deleteUser] function from [FirebaseUserMethods].
///
/// - [context]: The [BuildContext] of the current widget.
/// - [type]: The current user type.
/// - [uid]: The unique identifier of the user to be deleted.
///
/// Returns a [Future] representing the state of the dialog.
Future<void> _showDeleteConfirmationDialog(BuildContext context, String type, String uid) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // Dialog cannot be dismissed by tapping outside
    builder: (BuildContext dialogContext) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('تأكيد الحذف'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('هل تريد حقًا حذف هذا المستخدم؟'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('إلغاء'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text('حذف'),
              onPressed: () {
                FirebaseUserMethods(uid).deleteUser(context);
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
            ),
          ],
        ),
      );
    },
  );
}
