import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../users/users.dart';

Future<FirebaseUser?> readUser(BuildContext context, String uid) async{
  final docUser = FirebaseFirestore.instance.collection('users').doc(uid);
  final snapshot = await docUser.get();

  if(snapshot.exists) {
    return FirebaseUser.fromJson(snapshot.data()!);
  }
}

Future<bool> checkUserExist(BuildContext context, String uid) async{
  final docUser = FirebaseFirestore.instance.collection('users').doc(uid);
  final snapshot = await docUser.get();

  if(snapshot.exists) {
    return true;
  }
  return false;
}


String getUserId() {
  return FirebaseAuth.instance.currentUser!.uid;
}