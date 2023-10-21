import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/classReport/classReport.dart';
import 'package:daralarkam_main_app/backend/classroom/classroom.dart';

import '../counter/getCounter.dart';
import 'defaultReport.dart';

Future<ClassReport?> getReport(Classroom classroom) async {
  final docUser = FirebaseFirestore.instance.collection('classrooms').doc(classroom.classId);
  final docCounter = docUser.collection('classreports').doc(getFormattedDate());

  final docSnapshot = await docCounter.get();

  if (docSnapshot.exists) {
    return ClassReport.fromJson(docSnapshot.data()!);
  } else {
    // The document does not exist, create a new one
    await docCounter.set(defaultReport(classroom));
    return ClassReport.fromJson(docSnapshot.data()!);
  }
}
