import 'package:daralarkam_main_app/backend/classReport/classReport.dart';
import 'package:daralarkam_main_app/backend/classroom/classroomUtils.dart';
import 'package:daralarkam_main_app/backend/counter/getCounter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../ui/firebase/classrooms/classroomProfile.dart';
import '../../ui/widgets/text.dart';
import '../classroom/classroom.dart';

Future<Map<String, dynamic>> defaultReport(String classId) async {
  ClassReport report = ClassReport(
      date: getFormattedDate(),
      title: "",
      content: "",
      attendanceReport: await createAttendanceMap(classId)
  );

  return report.toJson();
}

Future<Map<String, dynamic>> createAttendanceMap(String cid) async {
  final attendanceMap = <String, dynamic>{};

  try {
    final Classroom? classroom = await readClassroom(cid);
    for (var studentId in classroom!.getStudentIds()) {
      attendanceMap[studentId] = 1;
    }
  } catch (e) {
    print("Error while creating attendance map: $e");
  }

  return attendanceMap;
}
