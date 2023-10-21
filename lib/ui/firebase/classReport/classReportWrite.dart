import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/classReport/classReport.dart';
import 'package:daralarkam_main_app/backend/classReport/classReportUtils.dart';
import 'package:daralarkam_main_app/backend/classroom/classroom.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/material.dart';

import '../../../backend/counter/getCounter.dart';
import '../../../backend/firebase/users/get-user.dart';
import '../../../backend/users/users.dart';
import '../../../services/utils/showSnackBar.dart';

class ClassReportWriteTab extends StatefulWidget {
  final Classroom classroom;
  final ClassReport report;
  const ClassReportWriteTab({Key? key, required this.classroom, required this.report}) : super(key: key);

  @override
  State<ClassReportWriteTab> createState() => _ClassReportWriteTabState();
}

class _ClassReportWriteTabState extends State<ClassReportWriteTab> {
  TextEditingController _title = TextEditingController();
  TextEditingController _summary = TextEditingController();
  Map<String, dynamic> _attendanceReport = {};

  @override
  Widget build(BuildContext context) {
    List<Student> students = [];
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder<Object>(
      future: getReport(widget.classroom),
      builder: (context, snapshot) {
        return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar:AppBar(
                iconTheme: const IconThemeData(
                  color: Colors.white, //change your color here
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () async {
                        widget.report.updateTitle(_title.text);
                        widget.report.updateSummary(_summary.text);

                        final docClass = FirebaseFirestore.instance.collection('classrooms').doc(widget.classroom.classId);
                        final docReport = docClass.collection('counter').doc(getFormattedDate());
                        final json = widget.report.toJson();

                        await docReport.set(json).onError((error, stackTrace) {showSnackBar(context, error.toString());});
                      },
                      child: boldColoredArabicText("حفظ", c:Colors.white)
                  )
                ],
              ),

              body: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10,),
                      SizedBox(height: height*.1,child: Image.asset("lib/assets/photos/logo.png"),),
                      const SizedBox(height: 10,),
                      boldColoredArabicText("تقرير الدرس التربوي"),
                      const SizedBox(height: 10,),

                      TextFormField(
                        controller: _title,
                        decoration: InputDecoration(labelText: 'عنوان الدرس:'),
                      ),

                      TextFormField(
                        controller: _summary,
                        maxLines: null,  // This allows multiple lines of text input.
                        keyboardType: TextInputType.multiline,  // Sets the keyboard to a multiline input mode.
                        decoration: const InputDecoration(
                          labelText: 'Enter your text',  // A label for the field.
                          border: OutlineInputBorder(),  // A border around the field.
                        ),
                      ),

                      buildStudent()
                    ],
                  ),
                ),
              ),
            )
        );
      }
    );
  }
  // Build a list tile for the students
  Widget buildStudent() {
    List<Widget> listTiles = [];

    for(dynamic uid in widget.report.attendanceReport.keys){
      ListTile tile = ListTile(
        title: FutureBuilder<FirebaseUser?>(
          future: readUser(context, uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...');
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error.toString()}');
            } else if (snapshot.hasData) {
              final dynamic student = snapshot.data;
              return ListTile(
                title: Text(student.firstName + " " + student.secondName + " " +
                    student.thirdName),
                subtitle: coloredArabicText(translateAttendanceCounterTypes(
                    widget.report.getStudentInfo(student.id))),
                trailing: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.report.updateStudent(student.id);
                    });
                  },
                  child: const Text('غيّر'),
                ),
              );
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
