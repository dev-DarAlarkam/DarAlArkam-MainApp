import 'package:daralarkam_main_app/backend/classReport/classReport.dart';
import 'package:daralarkam_main_app/backend/counter/getCounter.dart';

import '../classroom/classroom.dart';

Map<String, dynamic> defaultReport(Classroom classroom) {
  ClassReport report = ClassReport(
      date: getFormattedDate(),
      title: "",
      content: "",
      attendanceReport: createAttendanceMap(classroom.getStudentIds())
  );

  return report.toJson();
}

Map<String, dynamic> createAttendanceMap(List<String> studentIds) {
  final attendanceMap = <String, AttendanceCounterTypes>{};

  for (var studentId in studentIds) {
    attendanceMap[studentId] = AttendanceCounterTypes.DidntAttend;
  }

  return attendanceMap;
}