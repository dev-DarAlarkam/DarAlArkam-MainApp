import 'package:DarAlarkam/backend/firebase/navigator.dart';
import 'package:DarAlarkam/ui/Authenticate/authenticationTab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:DarAlarkam/globals/globalColors.dart' as colors;
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
                      onPressed: (){
                        if(FirebaseAuth.instance.currentUser == null) {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => const SignInTab()));
                        }
                        else {
                          navigateBasedOnType(context, FirebaseAuth.instance.currentUser!.uid);
                        }
                      },
                        child: SizedBox(width: width*0.12,child: Image.asset("lib/assets/photos/logo-white.png")),
                      ),
                  ),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

