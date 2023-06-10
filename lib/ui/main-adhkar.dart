import 'dart:core';
import 'package:daralarkam_main_app/ui/widgets/adhkar-buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:daralarkam_main_app/globals/globalColors.dart' as global;

class MainAdhkar extends StatelessWidget {
  const MainAdhkar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width =  MediaQuery.of(context).size.width;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar:AppBar(
          backgroundColor: Colors.transparent, //for hiding the appBar
          elevation: 0, //for hiding the shadows
        ),
        body: Center(
          child: SizedBox(
            height: height*0.5,
            width: width*0.5,
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.greenAccent
                ),
                child :Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // AdhkarButton(nextScreen: nextScreen),
                    // AdhkarButton(nextScreen: nextScreen)
              ],
            ))
            )
          )
      );
  }
}