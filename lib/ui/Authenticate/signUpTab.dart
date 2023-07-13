import 'package:daralarkam_main_app/services/firebaseAuthMethods.dart';
import 'package:daralarkam_main_app/ui/Authenticate/newUserTab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import '../../globals/globalColors.dart' as color;
import '../../services/utils/showSnackBar.dart';
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
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Expanded(flex:1,child: SizedBox()),
                    SizedBox(height: height*.1,child: Image.asset("lib/assets/photos/main-logo.png"),),
                    const Expanded(flex:1,child: SizedBox()),
                    boldColoredArabicText("إنشاء حساب"),
                    const Expanded(flex:1,child: SizedBox()),
                    reusableTextField("أدخل البريد الإلكتروني", Icons.person_outline, false, emailTextController),
                    const SizedBox(height: 10,),
                    reusableTextField("أدخل كلمة السر", Icons.lock_outline, true, passwordTextController),
                    const SizedBox(height: 10,),
                    signUpButton(context, "انشئ حساب",emailTextController ,passwordTextController),
                    const Expanded(flex:3,child: SizedBox()),
                  ]
                )
              ),
          )

    );
  }
}


Container signUpButton(BuildContext context, String title, TextEditingController email, TextEditingController password){
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        FirebaseAuthMethods(FirebaseAuth.instance)
            .signUpWithEmail(email: email.text, password: password.text, context: context)
            .then((value) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => NewUserTab()));
            });
      },
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

Row line() {
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
