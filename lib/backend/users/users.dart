import 'dart:core';
//Tested


class FirebaseUser {
  final String firstName;
  final String secondName;
  final String thirdName;
  final String birthday;
  final String id;
  final String type;

  FirebaseUser({
    required this.id,
    required this.firstName,
    required this.secondName,
    required this.thirdName,
    required this.birthday,
    required this.type,
  });

  String getFullName() {
    return firstName+" "+secondName+" "+thirdName;
  }


  Map<String, dynamic> toJson() => {
    "id" : id,
    "type" : type,
    'firstName' : firstName,
    'secondName' : secondName,
    'thirdName' : thirdName,
    "birthday" : birthday,
  };

  static FirebaseUser fromJson(Map<String, dynamic> data) => FirebaseUser(
      id: data['id'],
      firstName: data['firstName'],
      secondName: data['secondName'],
      thirdName: data['thirdName'],
      birthday: data['birthday'],
      type: data['type']
  );
}

class Teacher extends FirebaseUser {
  final List<String> classIds;

  Teacher({
    required String id,
    required String firstName,
    required String secondName,
    required String thirdName,
    required String birthday,
    required String type,
    required this.classIds,
  }) : super(
    id: id,
    firstName: firstName,
    secondName: secondName,
    thirdName: thirdName,
    birthday: birthday,
    type: type,
  );

  static Teacher fromFirebaseUser(FirebaseUser user, List<String> classIds) => Teacher(
      id: user.id,
      firstName: user.firstName,
      secondName: user.secondName,
      thirdName: user.thirdName,
      birthday: user.birthday,
      type: user.type,
      classIds: classIds,
    );

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = super.toJson();
    json['classIds'] = classIds;
    return json;
  }

  static Teacher fromJson(Map<String, dynamic> data) => Teacher(
    id: data['id'],
    firstName: data['firstName'],
    secondName: data['secondName'],
    thirdName: data['thirdName'],
    birthday: data['birthday'],
    type: data['type'],
    classIds: List<String>.from(data['classIds']),
  );
}

class Student extends FirebaseUser {
  final String classId;

  Student({
    required String id,
    required String firstName,
    required String secondName,
    required String thirdName,
    required String birthday,
    required String type,
    required this.classId,
  }) : super(
    id: id,
    firstName: firstName,
    secondName: secondName,
    thirdName: thirdName,
    birthday: birthday,
    type: type,
  );

  static Student fromFirebaseUser(FirebaseUser user, String classId) => Student(
      id: user.id,
      firstName: user.firstName,
      secondName: user.secondName,
      thirdName: user.thirdName,
      birthday: user.birthday,
      type: user.type,
      classId: classId,
    );

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = super.toJson();
    json['classId'] = classId;
    return json;
  }

  static Student fromJson(Map<String, dynamic> data) => Student(
    id: data['id'],
    firstName: data['firstName'],
    secondName: data['secondName'],
    thirdName: data['thirdName'],
    birthday: data['birthday'],
    type: data['type'],
    classId: data['classId'],
  );
}

class Supervisor extends Teacher {
  final List<String> teacherIds;

  Supervisor({
    required String id,
    required String firstName,
    required String secondName,
    required String thirdName,
    required String birthday,
    required String type,
    required List<String> classIds,
    required this.teacherIds,
  }) : super(
    id: id,
    firstName: firstName,
    secondName: secondName,
    thirdName: thirdName,
    birthday: birthday,
    type: type,
    classIds: classIds,
  );

  static Supervisor fromFirebaseUser(FirebaseUser user, List<String> classIds, List<String> teacherIds) {
    return Supervisor(
      id: user.id,
      firstName: user.firstName,
      secondName: user.secondName,
      thirdName: user.thirdName,
      birthday: user.birthday,
      type: user.type,
      classIds: classIds,
      teacherIds: teacherIds,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = super.toJson();
    json['teacherIds'] = teacherIds;
    return json;
  }

  static Supervisor fromJson(Map<String, dynamic> data) => Supervisor(
    id: data['id'],
    firstName: data['firstName'],
    secondName: data['secondName'],
    thirdName: data['thirdName'],
    birthday: data['birthday'],
    type: data['type'],
    classIds: List<String>.from(data['classIds']),
    teacherIds: List<String>.from(data['teacherIds']),
  );
}
