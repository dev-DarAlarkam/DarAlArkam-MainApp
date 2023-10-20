import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/classroom/classroom.dart';
import 'package:flutter/material.dart';

Future<Classroom?>  readClassroom(BuildContext context, String cid) async{
  final docClass = FirebaseFirestore.instance.collection('classrooms').doc(cid);
  final snapshot = await docClass.get();

  if(snapshot.exists) {
    return Classroom.fromJson(snapshot.data()!);
  }
}