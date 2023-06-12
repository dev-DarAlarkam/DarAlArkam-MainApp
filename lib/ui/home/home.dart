import 'dart:core';
import 'package:daralarkam_main_app/ui/Adhkar/after-salah.dart';
import 'package:daralarkam_main_app/ui/Adhkar/morning-evening.dart';
import 'package:daralarkam_main_app/ui/widgets/navigate-to-tab-button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:daralarkam_main_app/globals/globalColors.dart' as colors;
import 'package:flutter/painting.dart';


class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

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
              const NavigateToTabButton(text: "القرآن الكريم",icon: "lib/assets/icons/quran.png", nextScreen: MorningEvening()),
              const SizedBox(height: 10,),
              const NavigateToTabButton(text: "أوقات الصلاة",icon: "lib/assets/icons/salat.png", nextScreen: AfterSalah()),
              const SizedBox(height: 10,),
              const NavigateToTabButton(text: "الأذكار",icon: "lib/assets/icons/beads.png", nextScreen: MorningEvening()),
              const SizedBox(height: 10,),
              const NavigateToTabButton(text: "فعاليات",icon: "lib/assets/icons/drum.png", nextScreen: MorningEvening()),
              const SizedBox(height: 10,),
              const Expanded(flex:2,child: SizedBox()),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          notchMargin: 10.0,
          shape: CircularNotchedRectangle(),
          child: SizedBox(
            width: width,
            height: height*0.09,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.home,
                        color: colors.green,
                      ),
                      Text(
                        "Home",
                        style: TextStyle(color:colors.green),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.settings,
                        color: colors.green,
                      ),
                      Text(
                        "Setting",
                        style: TextStyle(color: colors.green),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: SizedBox(
          width: width *0.25,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: (){},
              child: SizedBox(width: width*0.12,child: Image.asset("lib/assets/photos/logo-white.png")),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}