import 'package:daralarkam_main_app/services/firebaseAuthMethods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import '../../globals/globalColors.dart' as color;
import '../../services/utils/showSnackBar.dart';
import '../../services/utils/signInTextField.dart';
import '../widgets/text.dart';
import 'authenticationTab.dart';



class SignUpTab extends StatefulWidget {
  const SignUpTab({Key? key}) : super(key: key);

  @override
  State<SignUpTab> createState() => _SignUpTabState();
}

class _SignUpTabState extends State<SignUpTab> {
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();

  void signUpUser() {
    FirebaseAuthMethods(FirebaseAuth.instance)
        .signUpWithEmail(
        email: emailTextController.text,
        password: passwordTextController.text,
        context: context
    ).then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SignInTab()),
            (route) => route.isFirst).onError((error, stackTrace) {showSnackBar(context, error.toString());}));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: IconThemeData(color: color.green,),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: SizedBox(
              width: width * 0.8,
              height: height,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Expanded(flex: 1, child: SizedBox()),
                    SizedBox(height: height * .1,
                      child: Image.asset("lib/assets/photos/main-logo.png"),),
                    const Expanded(flex: 1, child: SizedBox()),
                    boldColoredArabicText("إنشاء حساب"),
                    const Expanded(flex: 1, child: SizedBox()),
                    signInTextField("أدخل البريد الإلكتروني", Icons.person_outline, false, emailTextController),
                    const SizedBox(height: 10,),
                    signInTextField("أدخل كلمة السر", Icons.lock_outline, true, passwordTextController),
                    const SizedBox(height: 10,),
                    signUpButton(context, "انشئ حساب", emailTextController, passwordTextController),
                    const Expanded(flex: 3, child: SizedBox()),
                  ]
              )
          ),
        )

    );
  }

  Container signUpButton(BuildContext context, String title,
      TextEditingController email, TextEditingController password) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
        onPressed: (){
          signUpUser();
          },
        child: boldColoredArabicText(title),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.black26;
              }
              return Colors.white;
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)))),
      ),
    );
  }
}
