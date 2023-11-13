import 'package:daralarkam_main_app/backend/userManagement/firebaseUserMethods.dart';
import 'package:daralarkam_main_app/ui/firebase/statistics/statisticsForCounters.dart';
import 'package:daralarkam_main_app/ui/firebase/statistics/statisticsForStudent.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/material.dart';

import '../../../backend/userManagement/firebaseUserUtils.dart';
import '../counter/countersViewer.dart';

class ShowStudentDetailsTab extends StatelessWidget {
  const ShowStudentDetailsTab({Key? key, required this.uid, required this.cid}) : super(key: key);
  final String uid;
  final String cid;
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ملف الطالب الشخصي"),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 10,),

              const Icon(Icons.person),
              FutureBuilder(
                  future: FirebaseUserMethods(uid).fetchUserFromFirestore(),
                  builder: (context, snapshot){
                    if(snapshot.hasError){return Text(snapshot.error.toString());}
                    else if (snapshot.hasData) {
                      final dynamic user = snapshot.data;
                      // final user = FirebaseUser.fromJson(userDoc);
                      return Center(
                        child: SizedBox(
                          height: height*0.8,
                          child: Column(
                            children: [
                              //username
                              coloredArabicText(user.firstName + " " + user.secondName + " " + user.thirdName),
                              const SizedBox(height: 10,),
                              //type
                              coloredArabicText(translateUserTypes(user.type)),
                              const SizedBox(height: 10,),
                              //birthday
                              coloredArabicText(user.birthday),
                              const Expanded(child: SizedBox()),
                              ///Action buttons:

                              //counter viewer button
                              ElevatedButton(onPressed: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CountersViewer(uid: uid,)));
                              }, child: coloredArabicText("برنامج المحاسبة", c: Colors.white)),
                              const SizedBox(height: 10,),

                              //Counter Stats of the student
                              ElevatedButton(onPressed: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StatisticsForCounters(uid: uid)));
                              }, child: coloredArabicText("إحصائيات برنامج المحاسبة", c: Colors.white)),
                              const SizedBox(height: 10,),

                              //Attendance stats of the student
                              ElevatedButton(onPressed: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StatisticsForStudentTab(classId:cid,studentId: uid,)));
                              }, child: coloredArabicText("إحصائيات حضور الطالب", c: Colors.white)),

                            ],
                          ),
                        ),
                      );
                    }
                    else{return const Center(child: CircularProgressIndicator());}

                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
