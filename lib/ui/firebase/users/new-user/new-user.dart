import 'package:daralarkam_main_app/backend/counter/getCounter.dart';
import 'package:daralarkam_main_app/backend/userManagement/additionalInformationMethods.dart';
import 'package:daralarkam_main_app/backend/userManagement/firebaseUserMethods.dart';
import 'package:daralarkam_main_app/backend/users/additionalInformation.dart';
import 'package:daralarkam_main_app/ui/firebase/users/new-user/new_user_widgets.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:daralarkam_main_app/globals/globalColors.dart' as colors;

import '../../../../backend/userManagement/firebaseUserUtils.dart';
import '../../../../backend/users/firebaseUser.dart';

class NewUserTab extends StatefulWidget {
  const NewUserTab({Key? key}) : super(key: key);

  @override
  State<NewUserTab> createState() => _NewUserTabState();
}

class _NewUserTabState extends State<NewUserTab> {
  String birthday = getFormattedDate();
  DateTime _date = DateTime.now();
  TextEditingController firstName = TextEditingController(),
      fatherName = TextEditingController(),
      familyName = TextEditingController(),
      grandfatherName = TextEditingController(),
      groupName = TextEditingController(),
      teacherName = TextEditingController();

  // Widget for the sign-up button
  Widget signUpButton() {
    return Container(
      height: 50,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: colors.green,
      ),
      child: ElevatedButton(
        onPressed: () async {
          final user = FirebaseUser(
              id: getCurrentUserId(),
              firstName: firstName.text,
              fatherName: fatherName.text,
              grandfatherName: grandfatherName.text,
              familyName: familyName.text,
              birthday: birthday,
              type: "guest");

          final info = AdditionalInformation(
              id: getCurrentUserId(),
              groupName: groupName.text,
              teacherName: teacherName.text);

          FirebaseUserMethods(user.id).uploadUserToFirestore(context, user);
          AdditionalInformationMethods(user.id).uploadInfoToFirestore(context, info);
          },


        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith(
                (states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.black26;
              }
              return colors.green;
            },
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        child: coloredArabicText("انشئ حساب", c:Colors.white),
      ),
    );
  }

  // Widget for the birthday picker button
  // this function allows to pick the date of birth up to 5 years from the current date

  Widget birthdayButton(BuildContext context) {
    return Container(
      width: 140,
      height: 45,
      decoration: BoxDecoration(
          color: colors.green,
          borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: GestureDetector(
          onTap: () {
            showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1970),
                lastDate: DateTime(DateTime.now().year-5))
                .then((value) {
              setState(() {
                _date = value!;
                birthday = formatADate(_date);
              });
            });
          },
          child: coloredArabicText("إختر تاريخ ميلادك", c:Colors.white),
        ),
      ),
    );
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.green,),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: width * 0.9,
              height: height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(flex:1,child: SizedBox() ),
                  SizedBox(height: height * 0.1,child: Image.asset("lib/assets/photos/main-logo.png"),),
                  const Expanded(flex:1,child: SizedBox() ),
                  boldColoredArabicText("إنشاء حساب"),
                  const Expanded(flex:1,child: SizedBox() ),

                  // First name input box
                  inputTextField(context, "اسم الطالب/ة", firstName),
                  const SizedBox(height: 10,),
                  // Second name input box
                  inputTextField(context, "اسم الأب", fatherName),
                  const SizedBox(height: 10,),
                  // grandfather name input box
                  inputTextField(context, "اسم الجد", grandfatherName),
                  const SizedBox(height: 10,),
                  // Third name input box
                  inputTextField(context, "اسم العائلة", familyName),
                  const SizedBox(height: 10,),

                  const Divider(),

                  // Birthday picker
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      birthdayButton(context),
                      const SizedBox(width: 30,),
                      Container(child: coloredArabicText(birthday))
                    ],
                  ),

                  const Divider(),

                  inputTextField(context, "اسم المجموعة", groupName),
                  const SizedBox(height: 10,),
                  // Third name input box
                  inputTextField(context, "اسم المربي/ة", teacherName),

                  const Expanded(flex:1,child: SizedBox()),
                  signUpButton(),
                  const Expanded(flex:3,child: SizedBox()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
