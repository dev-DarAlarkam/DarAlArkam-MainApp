import 'firebaseUser.dart';

class Teacher extends FirebaseUser {
  final List<String> classIds;

  Teacher({
    required String id,
    required String firstName,
    required String fatherName,
    required String grandfatherName,
    required String familyName,
    required String birthday,
    required String type,
    required this.classIds,
  }) : super(
    id: id,
    firstName: firstName,
    fatherName: fatherName,
    grandfatherName: grandfatherName,
    familyName: familyName,
    birthday: birthday,
    type: type,
  );

  static Teacher fromFirebaseUser(FirebaseUser user, List<String> classIds) => Teacher(
    id: user.id,
    firstName: user.firstName,
    fatherName: user.fatherName,
    grandfatherName: user.grandfatherName,
    familyName: user.familyName,
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
    fatherName: data['fatherName'],
    grandfatherName: data['grandfatherName'],
    familyName: data['familyName'],
    birthday: data['birthday'],
    type: data['type'],
    classIds: List<String>.from(data['classIds']),
  );
}