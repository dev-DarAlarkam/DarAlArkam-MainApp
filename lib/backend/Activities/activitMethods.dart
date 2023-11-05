
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/services/utils/showSnackBar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import 'Activity.dart';

class ActivityMethods {
  final String id;
  ActivityMethods(this.id);

  Future<void> uploadANewActivityToFirestore(BuildContext context, Activity activity) async{
    final docActivity = FirebaseFirestore.instance.collection('activities').doc(id);
    final snapshot = await docActivity.get();

    if(!snapshot.exists) {
      await docActivity.set(activity.toJson()).then((_) {
        showSnackBar(context, "تمت إضافة الفعالية بنجاح");
      }).catchError((error, stackTrace) {
        showSnackBar(context, error.toString());
      });
    }
    else {
      print("this activity already exists");
    }
  }

  Future<void> updateAnActivityInFirestore(BuildContext context, Activity activity) async{
    final docActivity = FirebaseFirestore.instance.collection('activities').doc(id);
    final snapshot = await docActivity.get();

    if(snapshot.exists) {
      await docActivity.set(activity.toJson()).then((_) {
        showSnackBar(context, "تم تعديل الفعالية بنجاح");
      }).catchError((error, stackTrace) {
        showSnackBar(context, error.toString());
      });
    }
    else {
      showSnackBar(context, "هذه الفعالية غير موجودة");
    }
  }

  Future<bool> doesActivityExistInFirestore() async{
    final docActivity = FirebaseFirestore.instance.collection('activities').doc(id);
    final snapshot = await docActivity.get();

    if(snapshot.exists) {
      return true;
    }
    return false;
  }

  Future<Activity?> fetchActivityFromFirestore() async {
    final docActivity = FirebaseFirestore.instance.collection('activities').doc(id);
    final snapshot = await docActivity.get();

    if(snapshot.exists) {
      return Activity.fromJson(snapshot.data()!);
    }
    return null;
  }

  Future<void> deleteActivity(BuildContext context) async{
    final docActivity = FirebaseFirestore.instance.collection('activities').doc(id);
    final snapshot = await docActivity.get();

    if(snapshot.exists) {
      docActivity.delete().then((_) {
        showSnackBar(context, "تم الحذف بنجاح");

      }).catchError((error, stackTrace) {
        showSnackBar(context, error.toString());
      });
    }

  }

}