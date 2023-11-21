import 'firebaseUser.dart';

class Student extends FirebaseUser {
  final String classId;

  Student({
    required String id,
    required String firstName,
    required String fatherName,
    required String grandfatherName,
    required String familyName,
    required String birthday,
    required String type,
    required this.classId,
  }) : super(
    id: id,
    firstName: firstName,
    fatherName: fatherName,
    grandfatherName: grandfatherName,
    familyName: familyName,
    birthday: birthday,
    type: type,
  );

  static Student fromFirebaseUser(FirebaseUser user, String classId) => Student(
    id: user.id,
    firstName: user.firstName,
    fatherName: user.fatherName,
    grandfatherName: user.grandfatherName,
    familyName: user.familyName,
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
    fatherName: data['fatherName'],
    grandfatherName: data['grandfatherName'],
    familyName: data['familyName'],
    birthday: data['birthday'],
    type: data['type'],
    classId: data['classId'],
  );
}