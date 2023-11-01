import 'dart:core';
import 'package:daralarkam_main_app/backend/userManagement/firebaseUserMethods.dart';
import 'package:daralarkam_main_app/backend/userManagement/teacherMethods.dart';
import 'package:daralarkam_main_app/services/utils/showSnackBar.dart';
import 'package:daralarkam_main_app/ui/activities/activities.dart';
import 'package:daralarkam_main_app/ui/firebase/counter/counterScreenWrite.dart';
import 'package:daralarkam_main_app/ui/firebase/counter/countersViewer.dart';
import 'package:daralarkam_main_app/ui/home/home.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../backend/counter/getCounter.dart';
import '../../../../backend/userManagement/firebaseUserUtils.dart';
import '../../../../backend/users/users.dart';
import '../../../../services/firebaseAuthMethods.dart';
import '../../../widgets/navigate-to-tab-button.dart';
import '../../classrooms/classrooms-tab.dart';


class TeacherTab extends StatelessWidget {
  const TeacherTab({super.key});

  // Function to get the user's first name
  String getUserFirstName(FirebaseUser user) => user.firstName;

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
                    FirebaseAuthMethods(FirebaseAuth.instance).signOut(context);
                  },
                ),
              ], //for hiding the shadows
            ),

            body: FutureBuilder(
              future: TeacherMethods(getCurrentUserId()).fetchTeacherFromFirebase(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else if (snapshot.hasData){
                  final FirebaseUser user = snapshot.data! as FirebaseUser;
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(height: 10,),
                        SizedBox(height: height*.1,child: Image.asset("lib/assets/photos/logo.png"),),
                        const SizedBox(height: 10,),

                        //greeting message
                        coloredArabicText("السلام عليكم" +" "+ getUserFirstName(user)),
                        const Expanded(child: SizedBox()),

                        //teacher functions
                        SingleChildScrollView(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [

                                    //Title
                                    boldColoredArabicText("برنامج المحاسبة", minSize: 22),
                                    const SizedBox(height: 10,),

                                    //getting counter info for the day
                                    FutureBuilder(
                                      future: getCounter(getCurrentUserId()),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError){return SizedBox(height: height*0.1,);}
                                        else if(snapshot.hasData) {
                                          final dynamic counter = snapshot.data!;
                                          return navigationButtonFul(context,"برنامج اليوم",CounterScreenWrite(counter: counter));
                                        }
                                        else{return Center(child: const CircularProgressIndicator());}
                                      },
                                    ),
                                    const SizedBox(height: 10,),

                                    //Navigation button to the Counters Viewer Tab
                                    navigationButtonFul(context,"الأيام السابقة",CountersViewer(uid: getCurrentUserId(),)),
                                  ],
                                ),

                                Column(
                                  children: [
                                    //Title
                                    boldColoredArabicText("الدورة التربوية", minSize: 22),
                                    const SizedBox(height: 10,),

                                    //Navigation button to the classrooms tab
                                    navigationButtonFul(context,"إدارة المجموعات",ClassroomsTab()),
                                    const SizedBox(height: 10,),

                                    //disabled feature
                                    navigationButtonLess(context,"إحصائيات",Activities()),
                                  ],
                                ),
                              ]
                          ),
                        ),
                        const Expanded(flex:2,child: SizedBox()),
                      ],
                    ),
                  );

                } else {
                  return const Center(child: CircularProgressIndicator(),);
                }
              },
            )
        )
    );
  }
}
