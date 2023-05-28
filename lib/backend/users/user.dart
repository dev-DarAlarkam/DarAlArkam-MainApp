import 'dart:core';
import 'package:daralarkam_main_app/backend/users/name.dart';

enum UserType {
  Guest, Student, Teacher, Supervisor, Admin
}

class User {
  Name userName;
  DateTime birthday;
  final String id;
  String email = "";
  String _password = "";
  bool isLoggedIn = true;
  UserType type = UserType.Guest;

  User.withEmail(this.userName, this.birthday, this.id, this.email, this._password);
  User.withAuth(this.userName, this.birthday, this.id);

  bool getStatus() => isLoggedIn;
  Name getName() => userName;
  String getId() => id;
  UserType getType() => type;

  void logIn() {
    isLoggedIn = true;
  }
  void logOut() {
    isLoggedIn = false;
  }
  Map<String, String> toJson() => {
    "UserId" : id,
    "UserType" : type.toString(),
    "UserName" : userName.getAsString(),
    "Birthday" : birthday.toString(),
    "Status" : isLoggedIn.toString()
  };
}