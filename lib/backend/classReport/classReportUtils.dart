import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/classReport/classReport.dart';
import 'package:daralarkam_main_app/backend/classroom/classroom.dart';
import 'package:flutter/cupertino.dart';

import '../../services/utils/showSnackBar.dart';
import '../counter/getCounter.dart';
import 'defaultReport.dart';

/// Retrieves a class report from Firestore for a specified class and date.
///
/// This function fetches a class report document from Firestore based on the provided
/// class ID and date. If the document exists, it is returned; otherwise, a new report
/// is created and stored in Firestore, and the newly created report is returned.
///
/// - [classId]: The unique identifier of the class for which the report is fetched.
/// - [date]: The date for which the report is retrieved.
///
/// Returns a [ClassReport] if found, or create a new one if document doesn't exist.
Future<ClassReport?> fetchReportFromFirebase(String classId, String date) async {
  final docUser = FirebaseFirestore.instance.collection('classrooms').doc(classId);
  final docCounter = docUser.collection('classReports').doc(date);

  final docSnapshot = await docCounter.get();

  if (docSnapshot.exists) {
    return ClassReport.fromJson(docSnapshot.data()!);
  } else {
    // The document does not exist, create a new one
    final newReport = await defaultReport(classId);

    await docCounter.set(newReport);
    return fetchReportFromFirebase(classId, date);
  }
}

/// Deletes a class report from Firestore for a specified class and date.
///
/// This function removes a class report document from Firestore based on the provided
/// class ID and date. It displays a success message if the deletion is successful or
/// an error message if an error occurs during the deletion process.
///
/// - [context]: The current [BuildContext] used for displaying snackbar messages.
/// - [classId]: The unique identifier of the class for which the report is deleted.
/// - [date]: The date of the report to be deleted.
Future<void> deleteReport(BuildContext context, String classId, String date) async {
  final docClass = FirebaseFirestore.instance.collection('classrooms').doc(classId);
  final docReport = docClass.collection('classReports').doc(date);

  await docReport.delete().then((_) {
    showSnackBar(context, "تم حذف التقرير بنجاح");
  }).catchError((error) {
    showSnackBar(context, "حدث خطأ أثناء حذف التقرير: $error");
  });
}
