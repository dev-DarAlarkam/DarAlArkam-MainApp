import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/classReport/classReport.dart';
import 'package:daralarkam_main_app/backend/classroom/classroom.dart';
import 'package:flutter/cupertino.dart';

import '../../services/utils/showSnackBar.dart';
import '../counter/getCounter.dart';
import 'defaultReport.dart';

Future<ClassReport?> getReport(String classId, String date) async {
  final docUser = FirebaseFirestore.instance.collection('classrooms').doc(classId);
  final docCounter = docUser.collection('classReports').doc(date);

  final docSnapshot = await docCounter.get();

  if (docSnapshot.exists) {
    return ClassReport.fromJson(docSnapshot.data()!);
  } else {
    // The document does not exist, create a new one
    final newReport = await defaultReport(classId);

    await docCounter.set(newReport);
    return getReport(classId, date);
  }
}

// function to delete a report
Future<void> deleteReport(BuildContext context, String classId, String date) async {
  final docClass = FirebaseFirestore.instance.collection('classrooms').doc(classId);
  final docReport = docClass.collection('classReports').doc(date);

  await docReport.delete().then((_) {
    showSnackBar(context, "تم حذف التقرير بنجاح");
  }).catchError((error) {
    showSnackBar(context, "حدث خطأ أثناء حذف التقرير: $error");
  });

}