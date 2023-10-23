import 'package:daralarkam_main_app/services/firebaseAuthMethods.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../backend/userManagement/navigator.dart';
import '../../globals/globalColors.dart' as color;
import '../../services/utils/showSnackBar.dart';
import '../../services/utils/signInTextField.dart';
import 'authenticationWidgets.dart';

class AuthenticationTab extends StatefulWidget {
  const AuthenticationTab({Key? key}) : super(key: key);

  @override
  _AuthenticationTabState createState() => _AuthenticationTabState();
}

class _AuthenticationTabState extends State<AuthenticationTab> {
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();

  Widget signInButton(BuildContext context, String title, TextEditingController email, TextEditingController password) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
        onPressed: () {signInUser();},
        child: boldColoredArabicText(title),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.black26;
              }
              return Colors.white;
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
      ),
    );
  }

  void signInUser() async {
    try {
      await FirebaseAuthMethods(FirebaseAuth.instance).signInWithEmail(
        email: emailTextController.text,
        password: passwordTextController.text,
        context: context,
      );
      //check if the user is signed in
      if (FirebaseAuth.instance.currentUser != null){
        navigateBasedOnType(context, FirebaseAuth.instance.currentUser!.uid);
      }
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: color.green,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: width * 0.8,
              height: height,
              child: Column(
                children: <Widget>[
                  const Expanded(flex: 1, child: SizedBox()),
                  SizedBox(height: height * .1,
                    child: Image.asset("lib/assets/photos/main-logo.png"),),
                  const Expanded(flex: 1, child: SizedBox()),
                  boldColoredArabicText("تسجيل الدخول"),
                  const SizedBox(height: 10,),
                  signInTextField("أدخل البريد الإلكتروني", Icons.person_outline, false, emailTextController),
                  const SizedBox(height: 10,),
                  signInTextField("أدخل كلمة السر", Icons.lock_outline, true, passwordTextController),
                  const SizedBox(height: 10,),
                  signUpOption(context),
                  const SizedBox(height: 10,),
                  signInButton(context, "تسجيل الدخول", emailTextController, passwordTextController),
                  const SizedBox(height: 10,),
                  line(),
                  const SizedBox(height: 10,),
                  googleButton(context),
                  const SizedBox(height: 10,),
                  facebookButton(context),
                  const Expanded(flex: 3, child: SizedBox()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

