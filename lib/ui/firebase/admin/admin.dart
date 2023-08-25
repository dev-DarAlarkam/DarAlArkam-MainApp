import 'dart:core';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:daralarkam_main_app/globals/globalColors.dart' as colors;


class AdminTab extends StatelessWidget {
  const AdminTab({Key? key}) : super(key: key);

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
              boldColoredArabicText("", c: colors.green), //todo: add text based on the username
              const Expanded(flex:4,child: SizedBox()),
            ],
          ),
        )
    );
  }
}