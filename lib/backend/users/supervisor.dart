import 'dart:core';

import 'package:daralarkam_main_app/backend/users/teacher.dart';

import 'firebaseUser.dart';

class Supervisor extends Teacher {
  final List<String> teacherIds;

  Supervisor({
    required String id,
    required String firstName,
    required String fatherName,
    required String grandfatherName,
    required String familyName,
    required String birthday,
    required String type,
    required List<String> classIds,
    required this.teacherIds,
  }) : super(
    id: id,
    firstName: firstName,
    fatherName: fatherName,
    grandfatherName: grandfatherName,
    familyName: familyName,
    birthday: birthday,
    type: type,
    classIds: classIds,
  );

  static Supervisor fromFirebaseUser(FirebaseUser user, List<String> classIds, List<String> teacherIds) {
    return Supervisor(
      id: user.id,
      firstName: user.firstName,
      fatherName: user.fatherName,
      grandfatherName: user.grandfatherName,
      familyName: user.familyName,
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
    fatherName: data['fatherName'],
    grandfatherName: data['grandfatherName'],
    familyName: data['familyName'],
    birthday: data['birthday'],
    type: data['type'],
    classIds: List<String>.from(data['classIds']),
    teacherIds: List<String>.from(data['teacherIds']),
  );
}
