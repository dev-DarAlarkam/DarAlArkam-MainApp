import 'package:daralarkam_main_app/services/firebaseAuthMethods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import '../../globals/globalColors.dart' as color;
import '../../services/utils/showSnackBar.dart';
import '../../services/utils/signInTextField.dart';
import '../widgets/text.dart';
import 'authentication.dart';

class ResetPasswordTab extends StatefulWidget {
  const ResetPasswordTab({Key? key}) : super(key: key);

  @override
  State<ResetPasswordTab> createState() => _ResetPasswordTabState();
}

class _ResetPasswordTabState extends State<ResetPasswordTab> {
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();

  Container resetPasswordButton(BuildContext context, String title, TextEditingController email, TextEditingController password) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
        onPressed: (){resetPassword();},
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

  void resetPassword() {
    FirebaseAuth.instance
        .sendPasswordResetEmail(
        email: emailTextController.text)
        .then((value) => Navigator.of(context).pop())
        .catchError((error) {
          showSnackBar(context, error.toString());
    })

        .then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const AuthenticationTab()),
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            iconTheme: IconThemeData(color: color.green,),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: SizedBox(
                  width: width * 0.8,
                  height: height,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Expanded(flex: 1, child: SizedBox()),
                        SizedBox(height: height * 0.1, child: Image.asset("lib/assets/photos/main-logo.png"),),
                        const Expanded(flex: 1, child: SizedBox()),
                        boldColoredArabicText("إعادة ضبط كلمة المرور"),
                        const Expanded(flex: 1, child: SizedBox()),
                        signInTextField("أدخل البريد الإلكتروني", Icons.person_outline, false, emailTextController),
                        const SizedBox(height: 10,),
                        resetPasswordButton(context, "أعد الضبط", emailTextController, passwordTextController),
                        const Expanded(flex: 3, child: SizedBox()),
                      ]
                  )
              ),
            ),
          )

      ),
    );
  }
}
