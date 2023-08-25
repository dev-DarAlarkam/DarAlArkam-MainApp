import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/firebase/navigator.dart';
import 'package:daralarkam_main_app/backend/firebase/users/get-user.dart';
import 'package:daralarkam_main_app/backend/users/user.dart';
import 'package:daralarkam_main_app/services/utils/showSnackBar.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:daralarkam_main_app/globals/globalColors.dart' as colors;

class NewUserTab extends StatefulWidget {
  const NewUserTab({Key? key}) : super(key: key);

  @override
  State<NewUserTab> createState() => _NewUserTabState();
}

class _NewUserTabState extends State<NewUserTab> {
  String birthday = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
  DateTime _date = DateTime.now();
  TextEditingController firstName = TextEditingController(), secondName = TextEditingController(), thirdName = TextEditingController();

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
            color: colors.green,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),

        body: Center(
          child: SizedBox(
            width: width*0.9,
            height: height*0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(flex:1,child: SizedBox() ),
                  SizedBox(height: height*.1,child: Image.asset("lib/assets/photos/main-logo.png"),),
                  const Expanded(flex:1,child: SizedBox() ),
                  boldColoredArabicText("إنشاء حساب"),
                  const Expanded(flex:1,child: SizedBox() ),
                  //First name input box
                  SizedBox(
                    width: width*0.6,
                    height: height*0.05,
                    child: TextField(
                      controller: firstName,
                      enableSuggestions: true,
                      autocorrect: true,
                      cursorColor: Colors.black,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(
                          color: Colors.black,
                          // fontSize: 12,
                          fontFamily: 'kb'),
                      decoration: InputDecoration(
                        labelText: "اسم الطالب/ة",
                        labelStyle: TextStyle(
                          color: colors.green,
                          // fontSize: 16,
                        ),
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        fillColor: Colors.white24,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                            BorderSide(width: 0, style: BorderStyle.solid, color: colors.green)),
                      ),
                      keyboardType: TextInputType.name,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  //Second name input box
                  SizedBox(
                    width: width*0.6,
                    height: height*0.05,
                    child: TextField(
                      controller: secondName,
                      enableSuggestions: true,
                      autocorrect: true,
                      cursorColor: Colors.black,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(
                          color: Colors.black,
                          // fontSize: 12,
                          fontFamily: 'kb'),
                      decoration: InputDecoration(
                        labelText: "اسم الأب",
                        labelStyle: TextStyle(
                          color: colors.green,
                          // fontSize: 16,
                        ),
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        fillColor: Colors.white24,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                            BorderSide(width: 0, style: BorderStyle.solid, color: colors.green)),
                      ),
                      keyboardType: TextInputType.name,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  //Third name input box
                  SizedBox(
                    width: width*0.6,
                    height: height*0.05,
                    child: TextField(
                      controller: thirdName,
                      enableSuggestions: true,
                      autocorrect: true,
                      cursorColor: Colors.black,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(
                          color: Colors.black,
                          // fontSize: 12,
                          fontFamily: 'kb'),
                      decoration: InputDecoration(
                        labelText: "اسم العائلة",
                        labelStyle: TextStyle(
                          color: colors.green,
                          // fontSize: 16,
                        ),
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        fillColor: Colors.white24,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                            BorderSide(width: 0, style: BorderStyle.solid, color: colors.green)),
                      ),
                      keyboardType: TextInputType.name,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  //Birthday picker
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _birthdayButton(context),
                      const SizedBox(
                        width: 30,
                      ),
                      Container(child: coloredArabicText(birthday))
                    ],
                  ),
                  const Expanded(flex:1,child: SizedBox()),
                  signUpButton(),
                  const Expanded(flex:3,child: SizedBox()),
                ],
              ),
            ),
          ),
      ),
    );
  }
  Widget signUpButton() {
    return Container(
      height: 50,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: colors.green,
      ),
      child: Center(
        child: GestureDetector(
          onTap: () async {


            final user = FirebaseUser(
                id:  getUserId(),
                firstName: firstName.text,
                secondName: secondName.text,
                thirdName: thirdName.text,
                birthday: birthday,
                type: "guest");
            final json = user.toJson();
            final docUser = FirebaseFirestore.instance.collection('users').doc(getUserId());
            await docUser.set(json)
                .then((value) {navigateBasedOnType(context, getUserId());})
                .onError((error, stackTrace) {showSnackBar(context, error.toString());});
            },
          child: coloredArabicText("انشئ حساب", c:Colors.white),
        ),
      ),
    );
  }
  _birthdayButton(BuildContext context) {
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
              lastDate: DateTime(2222))
              .then((value) {
            setState(() {
              _date = value!;
              birthday =
              "${_date.day}/${_date.month}/${_date.year}";
            });
          });
        },
        child: coloredArabicText("إختر تاريخ ميلادك", c:Colors.white),
      ),
    ),
  );
}
}