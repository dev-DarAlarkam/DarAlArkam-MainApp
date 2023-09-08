import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:DarAlarkam/globals/globalColors.dart' as colors;
import 'package:flutter/widgets.dart';
var myGroup = AutoSizeGroup();
Widget boldColoredArabicText(String text, {Color c = Colors.black ,int maxLines = 1, double maxSize = 40, double minSize = 20}) {

  return AutoSizeText(
    text,
    style: TextStyle(
      fontFamily: 'kb',
      color: c,
    ),
    overflow: TextOverflow.fade,
    maxFontSize: maxSize,
    minFontSize: minSize,
    maxLines: maxLines,
    textDirection: TextDirection.rtl,
    textAlign: TextAlign.center,
    stepGranularity: 1,
  );
}

Widget coloredArabicText(String text, {Color c = Colors.black ,int maxLines = 1, double maxSize = 50, double minSize = 20}) {
  return AutoSizeText(
    text,
    style: TextStyle(
      fontFamily: 'kb',
      color: c,
    ),
    maxFontSize: maxSize,
    minFontSize: minSize,
    maxLines: maxLines,
    textDirection: TextDirection.rtl,
    textAlign: TextAlign.center,
    overflow: TextOverflow.fade,
  );
}



