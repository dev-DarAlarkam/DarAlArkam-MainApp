import 'package:flutter/material.dart';
import '../../globals/globalColors.dart' as color;

TextField signInTextField(String text, IconData icon, bool isPasswordType,TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.black,
    textDirection: TextDirection.ltr,
    style: const TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'kb'),
    decoration: InputDecoration(
    prefixIcon: Icon(icon, color:color.green,),
    labelText: text,
    labelStyle: TextStyle(color: color.green),
    filled: true,
    floatingLabelBehavior: FloatingLabelBehavior.never,
    fillColor: Colors.white24,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide:  BorderSide(width: 0, style: BorderStyle.solid)),
      ),
    keyboardType: isPasswordType ? TextInputType.visiblePassword : TextInputType.emailAddress,
  );
}
