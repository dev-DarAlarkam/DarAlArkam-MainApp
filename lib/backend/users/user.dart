import 'dart:core';
import 'package:daralarkam_main_app/backend/users/name.dart';

enum UserType {
  Guest, Student, Teacher, Supervisor, Admin
}

class User {
  Name userName;
  DateTime birthday;
  final String id;
  UserType type = UserType.Guest;

  User.withEmail(this.userName, this.birthday, this.id);
  User.withAuth(this.userName, this.birthday, this.id);

  Name getName() => userName;
  String getId() => id;
  UserType getType() => type;

  Map<String, String> toJson() => {
    "UserId" : id,
    "UserType" : type.toString(),
    "UserName" : userName.getAsString(),
    "Birthday" : birthday.toString(),
  };

  //todo: fromJson method
}