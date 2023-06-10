import 'package:flutter/material.dart';
import 'package:daralarkam_main_app/globals/globalColors.dart' as colors;

Widget GreenArabicText(String text) {
  return Text(
    text,
    style: TextStyle(
        fontFamily: 'kb',
        color: colors.green,
    ),
    textDirection: TextDirection.rtl,
    textAlign: TextAlign.center,
  );
}

Widget GreenArabicTextBold(String text) {
  return Text(text,
      style: TextStyle(
          fontFamily: 'kb',
          color: colors.green,
          fontWeight: FontWeight.bold

      ),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.center,
  );
}

Widget ColoredArabicText(Color c, String text) {
  return Text(
    text,
    textDirection: TextDirection.rtl,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontFamily: 'kb',
      color: c,
    ),
  );
}



