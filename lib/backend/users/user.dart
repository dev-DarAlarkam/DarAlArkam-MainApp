import 'dart:core';
import 'package:daralarkam_main_app/backend/users/name.dart';

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