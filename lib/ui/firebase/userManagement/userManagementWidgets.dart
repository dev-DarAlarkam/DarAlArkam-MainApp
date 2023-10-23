import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:daralarkam_main_app/globals/globalColors.dart' as colors;

import '../../../backend/userManagement/usersUtils.dart';
import '../../widgets/text.dart';

Widget userTypeChangeButton(BuildContext context, String uid,String oldType, String newType){
  final double height = MediaQuery.of(context).size.height;
  final double width = MediaQuery.of(context).size.width;
  return GestureDetector(
    onTap: () async {updateUser(context, uid, oldType, newType);},

    child: Container(
      height: height*0.1,
      width: width*0.4,
      decoration: BoxDecoration(
        color: colors.green,
        borderRadius: BorderRadiusDirectional.circular(10),
      ),
      child: Center(child: coloredArabicText("make "+newType, c: Colors.white)),
    ),
  );
}

Widget deleteUserButton(BuildContext context, String uid, String type){
  final double height = MediaQuery.of(context).size.height;
  final double width = MediaQuery.of(context).size.width;
  return GestureDetector(
    onTap: () async {
      deleteUser(context, type, uid);
    },

    child: Container(
      height: height*0.1,
      width: width*0.4,
      decoration: BoxDecoration(
        color: colors.green,
        borderRadius: BorderRadiusDirectional.circular(10),
      ),
      child: Center(child: coloredArabicText("delete user", c: Colors.white)),
    ),
  );
}