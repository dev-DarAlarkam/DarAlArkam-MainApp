import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:daralarkam_main_app/globals/globalColors.dart' as colors;
import '../../backend/salah/hijri-date.dart';

Widget salahRow(String name, String time, BuildContext context){
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;

  return Directionality(
    textDirection: TextDirection.rtl,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(flex:1,child: SizedBox()),
        Container(
            height: height*0.05,
            width: width*0.4,
            decoration: BoxDecoration(
              color: colors.green,
              borderRadius: BorderRadiusDirectional.circular(10),
            ),
            child: Center(child: coloredArabicText(name, c: Colors.white))
        ),
        const Expanded(flex:1,child: SizedBox()),
        Container(
            height: height*0.05,
            width: width*0.3,
            decoration: BoxDecoration(
              color: colors.green,
              borderRadius: BorderRadiusDirectional.circular(10),
            ),
            child: Center(child: coloredArabicText(time, c: Colors.white))
        ),
        const Expanded(flex:1,child: SizedBox()),
      ],
    ),
  );
}

Widget dateRow(BuildContext context){
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;

  return Directionality(
    textDirection: TextDirection.rtl,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            height: height*0.05,
            width: width*0.6,
            decoration: BoxDecoration(
              color: colors.green,
              borderRadius: BorderRadiusDirectional.circular(10),
            ),
            child: Center(child: coloredArabicText(getTodayDateH(), c: Colors.white))
        ),
      ],
    ),
  );
}
