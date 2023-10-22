import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/classReport/classReport.dart';
import 'package:daralarkam_main_app/backend/classReport/classReportUtils.dart';
import 'package:daralarkam_main_app/backend/classroom/classroom.dart';
import 'package:daralarkam_main_app/backend/firebase/users/get-user.dart';
import 'package:daralarkam_main_app/backend/users/users.dart';
import 'package:daralarkam_main_app/services/utils/showSnackBar.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';

class ClassReportWriteTab extends StatefulWidget {
  final String classId;
  final String date;
  const ClassReportWriteTab({Key? key, required this.classId, required this.date}) : super(key: key);

  @override
  State<ClassReportWriteTab> createState() => _ClassReportWriteTabState();
}

class _ClassReportWriteTabState extends State<ClassReportWriteTab> {
  TextEditingController _title = TextEditingController();
  TextEditingController _summary = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the text fields with existing report data if available.
    // You can fetch the report data here and update the text controllers.
    // For now, let's assume you fetch the data and set the controllers like this:
    _title.text = ''; // Replace with actual data
    _summary.text = ''; // Replace with actual data
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getReport(widget.classId, widget.date),
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
                actions: [
                  ElevatedButton(
                    onPressed: () async {
                      report.updateTitle(_title.text);
                      report.updateSummary(_summary.text);

                      final docClass =
                      FirebaseFirestore.instance.collection('classrooms').doc(widget.classId);
                      final docReport = docClass.collection('classReports').doc(report.date);
                      final json = report.toJson();

                      await docReport.set(json).onError((error, stackTrace) {
                        showSnackBar(context, error.toString());
                      });
                    },
                    child: boldColoredArabicText("حفظ", c: Colors.white),
                  )
                ],
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
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                        child: TextFormField(
                          controller: _title,
                          decoration: InputDecoration(labelText: 'عنوان الدرس:'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextFormField(
                          controller: _summary,
                          maxLines: null, // This allows multiple lines of text input.
                          keyboardType: TextInputType.multiline, // Sets the keyboard to a multiline input mode.
                          decoration: const InputDecoration(
                            labelText: 'ملخص الدرس:', // A label for the field.
                            border: OutlineInputBorder(), // A border around the field.
                          ),
                        ),
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
          future: readUser(uid),
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
  @override
  void dispose() {
    // Dispose the text controllers when this widget is disposed.
    _title.dispose();
    _summary.dispose();
    super.dispose();
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
        widget.student.firstName +
            " " +
            widget.student.secondName +
            " " +
            widget.student.thirdName,
      ),
      subtitle: Text(translateAttendanceCounterTypes(
          widget.report.getStudentInfo(widget.student.id))),
      trailing: ElevatedButton(
        onPressed: () {
          setState(() {
            widget.report.updateStudent(widget.student.id);
            // Update the subtitle here without changing the whole state.
            // You can access and update the subtitle of this tile here.
            // For example:
            // widget.report.updateSubtitleForStudent(widget.student.id, 'New Subtitle');
          });
        },
        child: const Text('غيّر'),
      ),
    );
  }
}
