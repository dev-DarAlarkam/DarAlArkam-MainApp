import 'package:flutter/material.dart';
import 'package:daralarkam_main_app/globals/globalColors.dart' as colors;

Widget inputTextField(BuildContext context, String labelText, TextEditingController controller) => SizedBox(
  width: MediaQuery.of(context).size.width * 0.6,
  height: MediaQuery.of(context).size.height * 0.05,
  child: TextField(
    controller: controller,
    enableSuggestions: true,
    autocorrect: true,
    cursorColor: Colors.black,
    textDirection: TextDirection.rtl,
    textAlign: TextAlign.right,
    textAlignVertical: TextAlignVertical.center,
    style: const TextStyle(
      color: Colors.black,
    ),
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: colors.green,
      ),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white24,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(width: 0, style: BorderStyle.solid, color: colors.green),
      ),
    ),
    keyboardType: TextInputType.name,
  ),
);
