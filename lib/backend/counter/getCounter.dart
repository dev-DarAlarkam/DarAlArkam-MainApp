import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/counter/counter.dart';
import 'package:flutter/cupertino.dart';

import 'defaultCounter.dart';

Future<Counter?> getCounter(String uid) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc(uid);
  final docCounter = docUser.collection('counter').doc(getFormattedDate());

  final docSnapshot = await docCounter.get();

  if (docSnapshot.exists) {
    return Counter.fromJson(docSnapshot.data()!);
  } else {
    // The document does not exist, create a new one
    await docCounter.set(defaultCounter(uid).toJson());
    return getCounter(uid);
  }
}


Future<bool> checkCounterExist(BuildContext context, String uid) async{
  final docUser = FirebaseFirestore.instance.collection('users').doc(uid);
  final docCounter = docUser.collection('counter').doc(getFormattedDate());
  final snapshot = await docCounter.get();

  if(snapshot.exists) {
    return true;
  }
  return false;
}

String getFormattedDate() {
  DateTime today = DateTime.now();
  String formattedDate = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

  return formattedDate;
}

String formatADate(DateTime date) {
  String formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  return formattedDate;
}


