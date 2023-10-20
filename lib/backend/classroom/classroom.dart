class Classroom {
  String classId;
  String title;
  String grade;
  String teacherId;
  List<String> studentIds;

  Classroom({
    required this.classId,
    required this.title,
    required this.grade,
    required this.teacherId,
    required this.studentIds,
  });

  getStudentIds() => studentIds;

  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      classId: json['classId'] as String,
      title: json['title'] as String,
      grade: json['grade'] as String,
      teacherId: json['teacherId'] as String,
      studentIds: (json['studentIds'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'classId': classId,
      'title': title,
      'grade' : grade,
      'teacherId': teacherId,
      'studentIds': studentIds,
    };
  }
}
