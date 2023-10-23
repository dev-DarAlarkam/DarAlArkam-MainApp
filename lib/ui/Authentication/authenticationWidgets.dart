import 'package:daralarkam_main_app/ui/Authentication/resetPassword.dart';
import 'package:daralarkam_main_app/ui/Authentication/signUpTab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../globals/globalColors.dart' as color;

import '../../backend/userManagement/navigator.dart';
import '../../services/firebaseAuthMethods.dart';
import '../../services/utils/showSnackBar.dart';
import '../widgets/my-flutter-app-icons.dart';
import '../widgets/text.dart';

Widget line() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        height: 1,
        width: 50,
        decoration: const BoxDecoration(color: Colors.black),
      ),
      const Text(
        "  أو  ",
        style: TextStyle(fontSize: 16),
      ),
      Container(
        height: 1,
        width: 50,
        decoration: const BoxDecoration(color: Colors.black),
      ),
    ],
  );
}

Widget signUpOption(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SignUpTab()));
        },
        child: boldColoredArabicText(
            "لا تملك حسابًا؟ قم بإنشاء حساب", maxSize: 15, minSize: 10),
      ),
      GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ResetPasswordTab()));
        },
        child: boldColoredArabicText(
            "أعد ضبط كلمة المرور", maxSize: 15, minSize: 10),
      ),

    ],
  );
}

Widget googleButton(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  return Container(
    height: 50,
    width: width*0.8,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      color: color.green,
    ),
    child: GestureDetector(
        onTap: () async {
          FirebaseAuthMethods(FirebaseAuth.instance)
              .signInWithGoogle(context)
              .then((value) {navigateBasedOnType(context, FirebaseAuth.instance.currentUser!.uid);})
              .onError((error, stackTrace) {showSnackBar(context, error.toString());});
        },
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              boldColoredArabicText("تسحيل الدخول بواسطة جوجل   ", c:Colors.white),
              const Icon(MyFlutterApp.google, color: Colors.white)
            ],
          ),
        )),
  );
}

Widget facebookButton(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  return Container(
    height: 50,
    width: width*0.8,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      color: color.green,
    ),
    child: GestureDetector(
        onTap: () async {
          FirebaseAuthMethods(FirebaseAuth.instance)
              .signInWithFacebook(context)
              .then((value) {navigateBasedOnType(context, FirebaseAuth.instance.currentUser!.uid);})
              .onError((error, stackTrace) {showSnackBar(context, error.toString());});
        },
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              boldColoredArabicText("تسحيل الدخول بواسطة فيسبوك   ", c:Colors.white),
              const Icon(MyFlutterApp.facebook_f, color: Colors.white)
            ],
          ),
        )),
  );
}