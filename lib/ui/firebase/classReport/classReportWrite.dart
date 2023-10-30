import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/classReport/classReport.dart';
import 'package:daralarkam_main_app/backend/classReport/classReportUtils.dart';
import 'package:daralarkam_main_app/backend/users/users.dart';
import 'package:daralarkam_main_app/services/utils/showSnackBar.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';

import '../../../backend/userManagement/firebaseUserUtils.dart';
final GlobalKey<FormState> _titleFormKey = GlobalKey<FormState>();
final GlobalKey<FormState> _summaryFormKey = GlobalKey<FormState>();
final TextEditingController _title = TextEditingController();
final TextEditingController _summary = TextEditingController();

class ClassReportWriteTab extends StatefulWidget {
  final String classId;
  final String date;
  const ClassReportWriteTab({Key? key, required this.classId, required this.date}) : super(key: key);

  @override
  State<ClassReportWriteTab> createState() => _ClassReportWriteTabState();
}

class _ClassReportWriteTabState extends State<ClassReportWriteTab> {

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
        }
        else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(
                color: Colors.white, //change your color here
              ),
            ),
            body: Center(child: Text('Error: ${snapshot.error.toString()}')),
          );
        }
        else if (snapshot.hasData) {
          final ClassReport report = snapshot.data! as ClassReport;
          _title.text = report.title;
          _summary.text = report.content;
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    onPressed:() async {
                      await _showDeleteConfirmationDialog(report, widget.classId);
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back)
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
                        child: Form(
                          key: _titleFormKey,
                          onChanged: () async {
                              report.updateTitle(_title.text);

                              final docClass =
                              FirebaseFirestore.instance.collection('classrooms').doc(widget.classId);
                              final docReport = docClass.collection('classReports').doc(report.date);
                              final json = report.toJson();

                              await docReport.set(json).onError((error, stackTrace) {
                                showSnackBar(context, error.toString());
                              });
                          },
                          child: TextFormField(
                            controller: _title,
                            decoration: InputDecoration(labelText: 'عنوان الدرس:'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Form(
                          key: _summaryFormKey,
                          onChanged: () async {
                            report.updateSummary(_summary.text);
                            final docClass =
                            FirebaseFirestore.instance.collection('classrooms').doc(widget
                                .classId);
                            final docReport = docClass.collection('classReports').doc(report
                                .date);
                            final json = report.toJson();

                            await docReport.set(json).onError((error, stackTrace) {
                              showSnackBar(context, error.toString());
                            });
                          },
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
                        child: buildCustomTiles(report),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        else {
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

  Widget buildCustomTiles(ClassReport report) {
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

  Future<void> _showDeleteConfirmationDialog(ClassReport report, String classId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Dialog cannot be dismissed by tapping outside
      builder: (BuildContext dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('تأكيد الحذف'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('هل تريد حقًا حذف هذه المجموعة؟'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('إلغاء'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
              TextButton(
                child: Text('حذف'),
                onPressed: () async  {
                  final docClass =
                  FirebaseFirestore.instance.collection('classrooms').doc(classId);
                  final docReport = docClass.collection('classReports').doc(report.date);
                  final json = report.toJson();

                  await docReport.set(json).onError((error, stackTrace) {
                    showSnackBar(context, error.toString());
                  });
                  Navigator.of(dialogContext).pop(); // Close the dialog
                },
              ),
            ],
          ),
        );
      },
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
          });
        },
        child: const Text('غيّر'),
      ),
    );
  }

}
