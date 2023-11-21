class FirebaseUser {
  final String firstName;
  final String fatherName;
  final String grandfatherName;
  final String familyName;
  late final String fullName;
  late final String userName;
  final String birthday;
  final String id;
  final String type;

  FirebaseUser({
    required this.id,
    required this.firstName,
    required this.fatherName,
    required this.grandfatherName,
    required this.familyName,
    required this.birthday,
    required this.type,
  }){

    fullName = firstName + " " + fatherName + " " + grandfatherName
        + " " + familyName;
    userName = firstName + " " + fatherName + " " + familyName;
  }


  Map<String, dynamic> toJson() => {
    "id" : id,
    "type" : type,
    'firstName' : firstName,
    'fatherName' : fatherName,
    'grandfatherName': grandfatherName,
    'familyName' : familyName,
    "birthday" : birthday,
  };

  static FirebaseUser fromJson(Map<String, dynamic> data) => FirebaseUser(
      id: data['id'],
      firstName: data['firstName'],
      fatherName: data['fatherName'],
      grandfatherName: data['grandfatherName'],
      familyName: data['familyName'],
      birthday: data['birthday'],
      type: data['type']
  );
}