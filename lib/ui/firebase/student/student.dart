import 'dart:core';
import 'package:daralarkam_main_app/backend/firebase/users/get-user.dart';
import 'package:daralarkam_main_app/services/utils/showSnackBar.dart';
import 'package:daralarkam_main_app/ui/activities/activities.dart';
import 'package:daralarkam_main_app/ui/firebase/counter/counterScreenWrite.dart';
import 'package:daralarkam_main_app/ui/firebase/counter/countersViewer.dart';
import 'package:daralarkam_main_app/ui/home/home.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../backend/counter/getCounter.dart';
import '../../../backend/users/users.dart';
import '../../widgets/navigate-to-tab-button.dart';


class StudentTab extends StatelessWidget {
  const StudentTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar:AppBar(
            iconTheme: const IconThemeData(
              color: Colors.white, //change your color here
            ),
            actions: [
              //Sign-out button
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  signOut(context);
                },
              ),
            ], //for hiding the shadows
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(height: 10,),
                SizedBox(height: height*.1,child: Image.asset("lib/assets/photos/logo.png"),),
                const SizedBox(height: 10,),
                //Getting user info
                FutureBuilder(
                  future: readUser(getUserId()),
                  builder: (context, snapshot) {
                    if (snapshot.hasError){return Text(snapshot.error.toString());}
                    else if(snapshot.hasData) {
                      final dynamic user = snapshot.data!;
                      return coloredArabicText("السلام عليكم" +" "+ getUserFirstName(user));
                    }
                    else{return const Center(child: CircularProgressIndicator());}
                  },
                ),
                const Expanded(child: SizedBox()),
                //Student functions
                SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            boldColoredArabicText("برنامج المحاسبة", minSize: 22),
                            const SizedBox(height: 10,),
                            FutureBuilder(
                              future: getCounter(getUserId()),
                              builder: (context, snapshot) {
                                if (snapshot.hasError){return SizedBox(height: height*0.1,);}
                                else if(snapshot.hasData) {
                                  final dynamic counter = snapshot.data!;
                                  return navigationButtonFul(context,"برنامج اليوم",CounterScreenWrite(counter: counter));
                                }
                                else{return Center(child: SizedBox(height: height*0.1, child: const CircularProgressIndicator()));}
                              },
                            ),
                            const SizedBox(height: 10,),
                            navigationButtonFul(context,"الأيام السابقة",CountersViewer(uid: getUserId(),)),
                          ],
                        ),

                        Column(
                          children: [
                            boldColoredArabicText("الدورة التربوية", minSize: 22),
                            const SizedBox(height: 10,),
                            navigationButtonLess(context,"ملخص حضوري",Activities()),
                            const SizedBox(height: 10,),
                            navigationButtonLess(context,"ملخص اللقاءات",Activities()),
                          ],
                        ),
                      ]
                  ),
                ),
                const Expanded(flex:2,child: SizedBox()),
              ],
            ),
          )
      ),
    );
  }
  signOut(BuildContext context) {
    FirebaseAuth.instance.signOut()
        .then((value) => Navigator.pop(context, const Home()))
        .then((value) {showSnackBar(context, "لقد تم تسجيل الخروج بنجاح!");});
  }
  String getUserFirstName(FirebaseUser user) => user.firstName;
}