import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/userManagement/firebaseUserMethods.dart';
import 'package:flutter/cupertino.dart';

import '../../services/utils/showSnackBar.dart';
import '../users/additionalInformation.dart';
import 'firebaseUserUtils.dart';
import 'navigator.dart';

class AdditionalInformationMethods {
  final String userId;

  AdditionalInformationMethods(this.userId);

  /// Uploads user information to firestore, but first checks the if
  /// the information is valid and not empty, and if everything is ok,
  /// it navigates to the next tab based on the user type
  Future<void> uploadInfoToFirestore(BuildContext context, AdditionalInformation info) async {
    if(await FirebaseUserMethods(userId).doesUserExistInFirestore()){
      if (info.groupName.isNotEmpty
          && info.teacherName.isNotEmpty) {
        final json = info.toJson();
        final docUser = FirebaseFirestore.instance
            .collection('additionalInformation')
            .doc(userId);

        await docUser.set(json).then((_){
          navigateBasedOnType(context, userId);
        }).catchError((error, stackTrace) {
          showSnackBar(context, error.toString());
        });
      }
      else {
        showSnackBar(context, "المعلومات غير كافية");
      }
    }


  }


  // Fetches user information from Firestore.
  Future<AdditionalInformation?> fetchInfoFromFirestore() async {
    final docUser = FirebaseFirestore.instance.collection('additionalInformation').doc(userId);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return AdditionalInformation.fromJson(snapshot.data()!);
    }
    return null;
  }

  // Checks if a user with the given UID exists in Firestore.
  Future<bool> doesInfoExistInFirestore() async {
    final docUser = FirebaseFirestore.instance.collection('additionalInformation').doc(userId);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return true;
    }
    return false;
  }

}