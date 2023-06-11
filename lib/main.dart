import 'package:daralarkam_main_app/ui/after-salah.dart';
import 'package:daralarkam_main_app/ui/main-adhkar.dart';
import 'package:daralarkam_main_app/ui/morning-evening.dart';
import 'package:flutter/material.dart';
import 'package:daralarkam_main_app/globals/globalColors.dart' as colors;


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                  primarySwatch: Colors.green,
                ),
        home: const MainAdhkar(),
        ),
      );
  }
}

