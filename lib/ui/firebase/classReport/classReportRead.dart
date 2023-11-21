import 'package:daralarkam_main_app/backend/userManagement/firebaseUserMethods.dart';
import 'package:flutter/material.dart';
import 'package:daralarkam_main_app/backend/classReport/classReport.dart';
import 'package:daralarkam_main_app/backend/classReport/classReportUtils.dart';
import 'package:daralarkam_main_app/backend/users/supervisor.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';

import '../../../backend/userManagement/firebaseUserUtils.dart';
import '../../../backend/users/firebaseUser.dart';
final GlobalKey<FormState> _titleFormKey = GlobalKey<FormState>();
final GlobalKey<FormState> _summaryFormKey = GlobalKey<FormState>();
final TextEditingController _title = TextEditingController();
final TextEditingController _summary = TextEditingController();

class ClassReportReadTab extends StatefulWidget {
  final String classId;
  final String date;
  const ClassReportReadTab({Key? key, required this.classId, required this.date}) : super(key: key);

  @override
  State<ClassReportReadTab> createState() => _ClassReportReadTabState();
}

class _ClassReportReadTabState extends State<ClassReportReadTab> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchReportFromFirebase(widget.classId, widget.date),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(
                color: Colors.white, //change your color here
              ),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(
                color: Colors.white, //change your color here
              ),
            ),
            body: Center(child: Text('Error: ${snapshot.error.toString()}')),
          );
        } else if (snapshot.hasData) {
          final ClassReport report = snapshot.data! as ClassReport;

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                iconTheme: const IconThemeData(
                  color: Colors.white, //change your color here
                ),
              ),
              body: SingleChildScrollView(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Image.asset("lib/assets/photos/logo.png"),
                      ),
                      const SizedBox(height: 10),
                      boldColoredArabicText("تقرير الدرس التربوي"),
                      const SizedBox(height: 10),
                      coloredArabicText("عنوان الدرس:", c: Colors.grey),
                      const SizedBox(height: 10),
                      Container(
                          decoration: BoxDecoration(
                              border: const Border(
                                top: BorderSide(color: Colors.grey),
                                right: BorderSide(color: Colors.grey),
                                left: BorderSide(color: Colors.grey),
                                bottom: BorderSide(color: Colors.grey),
                              ),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Text(report.title)
                      ),
                      const SizedBox(height: 10),
                      coloredArabicText("ملخص الدرس:", c: Colors.grey),
                      const SizedBox(height: 10),
                      Container(
                          decoration: BoxDecoration(
                              border: const Border(
                                top: BorderSide(color: Colors.grey),
                                right: BorderSide(color: Colors.grey),
                                left: BorderSide(color: Colors.grey),
                                bottom: BorderSide(color: Colors.grey),
                              ),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Text(report.content)
                      ),
                      const SizedBox(height: 10),
                      coloredArabicText("الحضور", c: Colors.grey),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                            border: const Border(
                              top: BorderSide(color: Colors.grey),
                              right: BorderSide(color: Colors.grey),
                              left: BorderSide(color: Colors.grey),
                              bottom: BorderSide(color: Colors.grey),
                            ),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: buildStudent(report),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(
                color: Colors.white, //change your color here
              ),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );

  }

  Widget buildStudent(ClassReport report) {
    List<Widget> listTiles = [];

    for (dynamic uid in report.attendanceReport.keys) {
      Widget tile = ListTile(
        title: FutureBuilder<FirebaseUser?>(
          future: FirebaseUserMethods(uid).fetchUserFromFirestore(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...');
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error.toString()}');
            } else if (snapshot.hasData) {
              final dynamic student = snapshot.data;
              return CustomListTile(student: student, report: report);
            }
            return Text('No data available.');
          },
        ),
      );

      listTiles.add(tile);
    }

    return ListView(
      children: listTiles,
    );
  }


}


class CustomListTile extends StatefulWidget {
  final FirebaseUser student;
  final ClassReport report;

  CustomListTile({required this.student, required this.report});

  @override
  _CustomListTileState createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.student.userName,
      ),
      trailing: Text(translateAttendanceCounterTypes(
          widget.report.getStudentInfo(widget.student.id))),
    );
  }
}
