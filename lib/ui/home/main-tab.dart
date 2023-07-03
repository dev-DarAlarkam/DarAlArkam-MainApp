import 'dart:core';
import 'package:daralarkam_main_app/ui/Adhkar/after-salah.dart';
import 'package:daralarkam_main_app/ui/Adhkar/main-adhkar.dart';
import 'package:daralarkam_main_app/ui/Adhkar/morning-evening.dart';
import 'package:daralarkam_main_app/ui/Quran/Quranmain.dart';
import 'package:daralarkam_main_app/ui/widgets/navigate-to-tab-button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:daralarkam_main_app/globals/globalColors.dart' as colors;
import 'package:flutter/painting.dart';


class MainTab extends StatelessWidget {
  const MainTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

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
              SizedBox(height: height*.1,child: Image.asset("lib/assets/photos/main-logo.png"),),
              const Expanded(flex:1,child: SizedBox()),
              const NavigateToStatefulTabButton(text: "القرآن الكريم",icon: "lib/assets/icons/quran.png", nextScreen: Quran()),
              const SizedBox(height: 10,),
              const NavigateToStatelessTabButton(text: "أوقات الصلاة",icon: "lib/assets/icons/salat.png", nextScreen: MainAdhkar()),
              const SizedBox(height: 10,),
              const NavigateToStatelessTabButton(text: "الأذكار",icon: "lib/assets/icons/beads.png", nextScreen: MainAdhkar()),
              const SizedBox(height: 10,),
              const NavigateToStatelessTabButton(text: "فعاليات",icon: "lib/assets/icons/drum.png", nextScreen: MainAdhkar()),
              const Expanded(flex:3,child: SizedBox()),
            ],
          ),
        ),
        );
  }
}