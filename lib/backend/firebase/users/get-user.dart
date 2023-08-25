import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../users/user.dart';

// Future<User?> readUser(BuildContext context, String uid) async{
//   final docUser = FirebaseFirestore.instance.collection('users').doc(uid);
//   final snapshot = await docUser.get();
//
//   if(snapshot.exists) {
//     return User.fromJson(snapshot.data()!);
//   }
// }