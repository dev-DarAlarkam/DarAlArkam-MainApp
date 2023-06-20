import 'package:daralarkam_main_app/ui/Adhkar/after-salah.dart';
import 'package:daralarkam_main_app/ui/Adhkar/main-adhkar.dart';
import 'package:daralarkam_main_app/ui/Adhkar/morning-evening.dart';
import 'package:daralarkam_main_app/ui/home/home.dart';
import 'package:daralarkam_main_app/ui/home/main-tab.dart';
import 'package:flutter/material.dart';


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
        home: const Home(),
        ),
      );
  }
}

