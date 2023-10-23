import 'package:daralarkam_main_app/services/firebaseAuthMethods.dart';
import 'package:daralarkam_main_app/ui/Authenticate/signUpTab.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../backend/firebase/navigator.dart';
import '../../globals/globalColors.dart' as color;
import '../../services/utils/showSnackBar.dart';
import '../../services/utils/signInTextField.dart';
import '../widgets/my-flutter-app-icons.dart';

class SignInTab extends StatefulWidget {
  const SignInTab({Key? key}) : super(key: key);

  @override
  _SignInTabState createState() => _SignInTabState();
}

class _SignInTabState extends State<SignInTab> {
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();

  void signInUser() async {
    try {
      await FirebaseAuthMethods(FirebaseAuth.instance).signInWithEmail(
        email: emailTextController.text,
        password: passwordTextController.text,
        context: context,
      );
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
                signUpOption(),
                const SizedBox(height: 10,),
                signInButton(context, "تسجيل الدخول", emailTextController, passwordTextController),
                const SizedBox(height: 10,),
                line(),
                const SizedBox(height: 10,),
                googleButton(),
                const SizedBox(height: 10,),
                facebookButton(),
                const Expanded(flex: 3, child: SizedBox()),
              ],
            ),
          ),
        ),
      ),
    );
  }

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

  Widget signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpTab()));
          },
          child: boldColoredArabicText(
              "لا تملك حسابًا؟ قم بإنشاء حساب", maxSize: 15, minSize: 10),
        ),
      ],
    );
  }

  Widget signInButton(BuildContext context, String title,
      TextEditingController email, TextEditingController password) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
        onPressed: () {
          signInUser();
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
  Widget googleButton() {
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
  Widget facebookButton() {
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
}

