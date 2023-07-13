import 'package:daralarkam_main_app/ui/Authenticate/signUpTab.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/material.dart';
import '../../globals/globalColors.dart' as color;
import '../widgets/my-flutter-app-icons.dart';

class SignInTab extends StatefulWidget {
  const SignInTab({Key? key}) : super(key: key);

  @override
  _SignInTabState createState() => _SignInTabState();
}

class _SignInTabState extends State<SignInTab> {
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();

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
              reusableTextField(
                  "أدخل البريد الإلكتروني", Icons.person_outline, false,
                  emailTextController),
              const SizedBox(height: 10,),
              reusableTextField("أدخل كلمة السر", Icons.lock_outline, true,
                  passwordTextController),
              const SizedBox(height: 10,),
              signUpOption(),
              const SizedBox(height: 10,),
              line(),
              const Expanded(flex: 3, child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }


  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpTab()));
          },
          child: boldColoredArabicText("لا تملك حسابًا؟ قم بإنشاء حساب", maxSize: 15, minSize: 10),
        ),
      ],
    );
  }
}

TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.black,
    textDirection: TextDirection.ltr,
    style: const TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'kb'),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color:color.green,
      ),
      labelText: text,
      labelStyle: TextStyle(color: color.green),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white24,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide:  BorderSide(width: 0, style: BorderStyle.solid)),

    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}