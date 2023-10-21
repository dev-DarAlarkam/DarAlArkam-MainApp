import 'package:daralarkam_main_app/backend/classroom/classroom.dart';
import 'package:daralarkam_main_app/backend/classroom/classroomUtils.dart';
import 'package:daralarkam_main_app/ui/firebase/classrooms/addStudentsToClass.dart';
import 'package:daralarkam_main_app/ui/firebase/classrooms/showClassStudents.dart';
import 'package:flutter/material.dart';

import '../../activities/activities.dart';
import '../../widgets/navigate-to-tab-button.dart';
import '../../widgets/text.dart';

class ClassroomProfileTab extends StatefulWidget {
  const ClassroomProfileTab({Key? key, required this.cid}) : super(key: key);
  final cid;
  @override
  State<ClassroomProfileTab> createState() => _ClassroomProfileTabState();
}

class _ClassroomProfileTabState extends State<ClassroomProfileTab> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar:AppBar(
            iconTheme: const IconThemeData(
              color: Colors.white, //change your color here
            ),
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
                  future: readClassroom(context, widget.cid),
                  builder: (context, snapshot) {
                    if (snapshot.hasError){return Text(snapshot.error.toString());}
                    else if(snapshot.hasData) {
                      final dynamic classroom = snapshot.data!;
                      return coloredArabicText("مجموعة " + getClassroomTitle(classroom));
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
                            const SizedBox(height: 10,),
                            navigationButtonFul(context,"الطلاب",ShowClassStudentsTab(classId: widget.cid,)),
                            const SizedBox(height: 10,),
                            navigationButtonFul(context,"اضافة طالب",AddStudentsToClassroomTab(classId: widget.cid,)),
                          ],
                        ),

                        Column(
                          children: [
                            const SizedBox(height: 10,),
                            navigationButtonLess(context,"التقارير",Activities()),
                            const SizedBox(height: 10,),
                            navigationButtonLess(context,"اضافة تقرير",Activities()),
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
}
String getClassroomTitle(Classroom c) => c.title;

