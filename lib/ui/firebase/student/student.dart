import 'dart:core';
import 'package:daralarkam_main_app/backend/firebase/users/usersUtils.dart';
import 'package:daralarkam_main_app/services/utils/showSnackBar.dart';
import 'package:daralarkam_main_app/ui/activities/activities.dart';
import 'package:daralarkam_main_app/ui/firebase/classReport/classReportsViewerForStudents.dart';
import 'package:daralarkam_main_app/ui/firebase/counter/counterScreenWrite.dart';
import 'package:daralarkam_main_app/ui/firebase/counter/countersViewer.dart';
import 'package:daralarkam_main_app/ui/firebase/statistics/statisticsForStudent.dart';
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
      child: FutureBuilder(
        future: readStudent(getCurrentUserId()),
        builder: (context, snapshot) {
          if (snapshot.hasError){return Text(snapshot.error.toString());}
          else if(snapshot.hasData) {
            final Student user = snapshot.data! as Student;
            return Scaffold(
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
                      coloredArabicText("السلام عليكم" +" "+ getUserFirstName(user)),
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
                                    future: getCounter(getCurrentUserId()),
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
                                  navigationButtonFul(context,"الأيام السابقة",CountersViewer(uid: getCurrentUserId(),)),
                                ],
                              ),

                              Column(
                                children: [
                                  boldColoredArabicText("الدورة التربوية", minSize: 22),
                                  const SizedBox(height: 10,),
                                  navigationButtonLess(context,"ملخص حضوري",StatisticsForStudentTab(classId: user.classId, studentId: user.id)),
                                  const SizedBox(height: 10,),
                                  navigationButtonFul(context,"ملخص اللقاءات",ClassReportsViewerForStudents(classId: user.classId)),
                                ],
                              ),
                            ]
                        ),
                      ),
                      const Expanded(flex:2,child: SizedBox()),
                    ],
                  ),
                )
            );
          }
          else{return const Center(child: CircularProgressIndicator());}
        },
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