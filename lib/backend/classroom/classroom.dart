class Classroom {
  String title;
  int grade;
  String teacherId;
  List<String> studentIds;

  Classroom({
    required this.title,
    required this.grade,
    required this.teacherId,
    required this.studentIds,
  });

  getStudentIds() => studentIds;

  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      title: json['title'] as String,
      grade: json['grade'] as int,
      teacherId: json['teacherId'] as String,
      studentIds: (json['studentIds'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'grade' : grade,
      'teacherId': teacherId,
      'studentIds': studentIds,
    };
  }
}
