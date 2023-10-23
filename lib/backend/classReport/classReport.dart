enum AttendanceCounterTypes {
  Unknown,
  DidntAttend,
  WithExuse,
  Late,
  Attented,
}

String translateAttendanceCounterTypes (AttendanceCounterTypes x) {
  switch (x.index) {
    case 0 :
      return "لا توجد معلومات";
    case 1 :
      return "غائب";
    case 2 :
      return "غائب مع عذر";
    case 3 :
      return "تأخر";
    case 4 :
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

  AttendanceCounterTypes getStudentInfo(String id) {
    const values = AttendanceCounterTypes.values;
    if (attendanceReport[id] != null){
      return values[attendanceReport[id]];
    }
    else {
      return AttendanceCounterTypes.Unknown;
    }

  }

  int _getNextEnumValue(int current) {
    const values = AttendanceCounterTypes.values;
    final nextIndex = (current + 1) % values.length;
    return nextIndex == 0 ? 1 : nextIndex;
  }

  factory ClassReport.fromJson(Map<String, dynamic> json) {
    // Parse attendanceReport as a Map<String, int>
    final Map<String, int> attendanceMap = Map<String, int>.from(json['attendanceReport']);

    // Create a ClassReport instance using the parsed data
    final report = ClassReport(
      date: json['date'],
      title: json['title'],
      content: json['content'],
      attendanceReport: attendanceMap,
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