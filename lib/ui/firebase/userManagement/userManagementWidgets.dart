import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:daralarkam_main_app/globals/globalColors.dart' as colors;

import '../../../backend/userManagement/usersUtils.dart';
import '../../widgets/text.dart';

Widget userTypeChangeButton(BuildContext context, String uid,String oldType, String newType, String title){
  final double height = MediaQuery.of(context).size.height;
  final double width = MediaQuery.of(context).size.width;
  return ElevatedButton(
      onPressed: () async {updateUser(context, uid, oldType, newType);},
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
                deleteUser(context, type, uid);
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
            ),
          ],
        ),
      );
    },
  );
}