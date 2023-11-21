class AdditionalInformation {
  final String id;
  final String groupName;
  final String teacherName;

  AdditionalInformation({
    required this.id,
    required this.groupName,
    required this.teacherName,
  });


  Map<String, dynamic> toJson() => {
    "id" : id,
    'groupName' : groupName,
    'teacherName' : teacherName,
  };

  static AdditionalInformation fromJson(Map<String, dynamic> data) => AdditionalInformation(
      id: data['id'],
      groupName: data['groupName'],
      teacherName: data['teacherName']
  );
}