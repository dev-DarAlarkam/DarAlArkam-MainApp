import 'dart:core';
import 'package:daralarkam_main_app/ui/Adhkar/after-salah.dart';
import 'package:daralarkam_main_app/ui/Adhkar/morning-evening.dart';
import 'package:daralarkam_main_app/ui/widgets/navigate-to-tab-button.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:daralarkam_main_app/globals/globalColors.dart' as colors;


class MainAdhkar extends StatelessWidget {
  const MainAdhkar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar:AppBar(
          iconTheme: IconThemeData(
            color: colors.green, //change your color here
          ),
          backgroundColor: Colors.transparent, //for hiding the appBar
          elevation: 0, //for hiding the shadows
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height*.1,child: Image.asset("lib/assets/photos/logo.png"),),
              const Expanded(flex:1,child: SizedBox()),
              boldColoredArabicText("الأذكار", c: colors.green, minSize: 40, maxSize: 50),
              const Expanded(flex:1,child: SizedBox()),
              const NavigateToTabButton(text: "المأثورات",icon: "lib/assets/icons/beads.png", nextScreen: MorningEvening()),
              const SizedBox(height: 10,),
              const NavigateToTabButton(text: "ما بعد الصلاة",icon: "lib/assets/icons/pray.png", nextScreen: AfterSalah()),
              const Expanded(flex:4,child: SizedBox()),
            ],
          ),
        )
      );
  }
}