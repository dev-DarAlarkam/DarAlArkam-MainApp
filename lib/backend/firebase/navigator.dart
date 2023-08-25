import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../ui/Authenticate/authenticationTab.dart';

void navigator(BuildContext context) {
  final firebaseUser = FirebaseAuth.instance.currentUser;

  if (firebaseUser != null) {
    navigatorBasedOnType(context, firebaseUser.uid);
  }
  Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInTab()));
}

void navigatorBasedOnType(BuildContext, String uid){

//todo

}