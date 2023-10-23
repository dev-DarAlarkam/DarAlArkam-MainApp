import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/classroom/classroomUtils.dart';
import 'package:flutter/material.dart';
import 'package:daralarkam_main_app/globals/globalColors.dart' as colors;

import '../../../backend/classReport/classReport.dart';
import '../../widgets/text.dart';

class StatisticsForStudentTab extends StatelessWidget {
  final String classId;
  final String studentId;
  const StatisticsForStudentTab({super.key, required this.classId, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(
                color: Colors.white
            ),
          ),

          body: classId == ''
              ? Center(child: boldColoredArabicText("لا تنتمي لمجموعة حالياً"))
              : StreamBuilder(
                  stream: readReportsFromAClassRoom(classId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (snapshot.hasData) {
                      final List<ClassReport> reports =
                          snapshot.data as List<ClassReport>;
                      List<Widget> rows = [];
                      Map<AttendanceCounterTypes, int> stats = {
                        AttendanceCounterTypes.Unknown : 0,
                        AttendanceCounterTypes.DidntAttend: 0,
                        AttendanceCounterTypes.WithExuse: 0,
                        AttendanceCounterTypes.Late: 0,
                        AttendanceCounterTypes.Attented: 0
                      };

                      for (ClassReport report in reports) {
                        AttendanceCounterTypes info =
                            report.getStudentInfo(studentId);
                        if (stats[info] != null) {
                          stats[info] = stats[info]! + 1;
                        }
                      }
                      for (AttendanceCounterTypes value in AttendanceCounterTypes.values) {
                        if (stats[value] != null) {
                          if (value != AttendanceCounterTypes.Unknown){
                            rows.add(infoRow(
                                translateAttendanceCounterTypes(value),
                                stats[value]!,
                                context));
                            rows.add(const SizedBox(
                              height: 10,
                            ));
                          }
                        }
                      }

                      return Center(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height *0.4,
                          child: Column(
                            children: rows,
                          ),
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
              ),
        )
    );
  }

  Stream<List<ClassReport>> readReportsFromAClassRoom(String classId) =>
      FirebaseFirestore.instance
          .collection('classrooms')
          .doc(classId)
          .collection('classReports')
          .snapshots()
          .map((event) => event.docs.map((e) => ClassReport.fromJson(e.data())).toList());


  Widget infoRow(String name, int stat, BuildContext context){
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(flex:1,child: SizedBox()),
          Container(
              height: height*0.05,
              width: width*0.4,
              decoration: BoxDecoration(
                color: colors.green,
                borderRadius: BorderRadiusDirectional.circular(10),
              ),
              child: Center(child: coloredArabicText(name, c: Colors.white))
          ),
          const Expanded(flex:1,child: SizedBox()),
          Container(
              height: height*0.05,
              width: width*0.3,
              decoration: BoxDecoration(
                color: colors.green,
                borderRadius: BorderRadiusDirectional.circular(10),
              ),
              child: Center(child: coloredArabicText("$stat", c: Colors.white))
          ),
          const Expanded(flex:1,child: SizedBox()),
        ],
      ),
    );
  }
}