enum AttendanceCounterTypes {
  DidntAttend,
  WithExuse,
  Late,
  Attented
}

String translateAttendanceCounterTypes (AttendanceCounterTypes x) {
  switch (x.index) {
    case 0 :
      return "غائب";
    case 1 :
      return "غائب مع عذر";
    case 2 :
      return "تأخر";
    case 3 :
      return "حاضر";
    default :
      return "";
  }
}


class ClassReport {
  final String date;
  String title;
  String content;
  Map<String, dynamic> attendanceReport;

  ClassReport({
    required this.date,
    required this.title,
    required this.content,
    required this.attendanceReport
  });


  updateStudent(String id) {
    attendanceReport[id] =  _getNextEnumValue(attendanceReport[id]);
  }

  updateTitle(String _title) {
    title = _title;
  }

  updateSummary(String _summary) {
    content = _summary;
  }

  AttendanceCounterTypes getStudentInfo(String id) => attendanceReport[id];

  AttendanceCounterTypes _getNextEnumValue(AttendanceCounterTypes current) {
    const values = AttendanceCounterTypes.values;
    final nextIndex = (current.index + 1) % values.length;
    return values[nextIndex];
  }

  factory ClassReport.fromJson(Map<String,dynamic> json) {
    final report = ClassReport(
        date: json['date'],
        title: json['title'],
        content: json['content'],
        attendanceReport: json['attendanceReport']
    );
    return report;
  }

  Map<String, dynamic> toJson() => {
    'date' : date,
    'title' : title,
    'content' : content,
    'attendanceReport' : attendanceReport
  };


}