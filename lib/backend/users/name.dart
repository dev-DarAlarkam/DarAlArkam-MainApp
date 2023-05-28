import 'dart:core';


class Name{
  String firstName;
  String secondName;
  String lastName;

  Name(this.firstName,this.secondName,this.lastName);

  String getAsString(){
    return firstName + secondName + lastName;
  }

}