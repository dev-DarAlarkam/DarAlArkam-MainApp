import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:daralarkam_main_app/globals/globalColors.dart' as colors;
import '../widgets/my-flutter-app-icons.dart';
import 'aboutus.dart';
import 'main-tab.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final tabs = [const MainTab(), const AboutUs()];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: tabs[_currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _currentIndex,
                selectedItemColor: colors.green,
                onTap: (index) => setState(() => _currentIndex = index),
                items: const [
                  BottomNavigationBarItem(icon: Icon(MyFlutterApp.home), label: ("رئيسية")),
                  BottomNavigationBarItem(icon: Icon(MyFlutterApp.question,), label: "من نحن"),
                ],
              ),
              floatingActionButton: SizedBox(
                 width: width *0.25,
                  child: FittedBox(
                      child: FloatingActionButton(
                      onPressed: (){},
                        child: SizedBox(width: width*0.12,child: Image.asset("lib/assets/photos/logo-white.png")),
                      ),
                  ),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

