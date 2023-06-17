import 'package:flutter/material.dart';

List<BoxShadow> Shadow(){
  return [BoxShadow(
    color: Colors.grey.withOpacity(.2),
    spreadRadius: 3,
    blurRadius: 7,
    offset: const Offset(0,6), // changes position of shadow
  )];
}