import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/classReport/classReport.dart';
import 'package:daralarkam_main_app/backend/users/users.dart';
import 'package:daralarkam_main_app/ui/firebase/classReport/classReportWrite.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/material.dart';
import '../../../../services/utils/showSnackBar.dart';
import 'classReportRead.dart';

// Enum to determine the sort order for students' list
enum SortOrder { ascending, descending }

class ClassReportsViewerTab extends StatefulWidget {
  const ClassReportsViewerTab({Key? key,required this.classId}) : super(key: key);
  final String classId;

  @override
  State<ClassReportsViewerTab> createState() => _ClassReportsViewerTabState();
}

class _ClassReportsViewerTabState extends State<ClassReportsViewerTab> {
  // Keeps track of the current sort order (ascending by default)
  SortOrder _currentSortOrder = SortOrder.ascending;
  // List to store students data
  List<ClassReport> reports = [];

  // Stream to read students who are not in any classroom
  Stream<List<ClassReport>> readReportsFromAClassRoom(String classId) =>
      FirebaseFirestore.instance
          .collection('classrooms')
          .doc(classId)
          .collection('classReports')
          .snapshots()
          .map((event) => event.docs.map((e) => ClassReport.fromJson(e.data())).toList());

  // Function to sort students based on their first names
  void sortReports(SortOrder order) {
    if (order == SortOrder.ascending) {
      reports.sort((a, b) => a.date.compareTo(b.date));
    } else {
      reports.sort((a, b) => b.date.compareTo(a.date));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("التقارير"),
          actions: [
            // Sort button in the app bar
            IconButton(
              icon: Icon(Icons.sort),
              onPressed: () {
                // Toggle the sort order and update the list
                final newOrder = _currentSortOrder == SortOrder.ascending
                    ? SortOrder.descending
                    : SortOrder.ascending;
                sortReports(newOrder);
                setState(() {
                  _currentSortOrder = newOrder;
                });
              },
            )
          ],
        ),
        body: Center(
          child: StreamBuilder(
            stream: readReportsFromAClassRoom(widget.classId),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else if (snapshot.hasData) {
                reports = snapshot.data as List<ClassReport>;
                sortReports(_currentSortOrder);
                return Center(
                  child: ListView(
                    children: reports.map(buildStudent).toList(),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }

  // Build a list tile for a student
  Widget buildStudent(ClassReport report) => ListTile(
    title: Text(report.date),
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> ClassReportReadTab(classId: widget.classId, date: report.date)));
    },
    trailing: SizedBox(
      width: MediaQuery.of(context).size.width * 0.35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              deleteReport(widget.classId, report.date);
              // setState(() {});
            },
            child: const Text("حذف", style: TextStyle(color: Colors.white),),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ClassReportWriteTab(classId: widget.classId, date: report.date)));
            },
            child: const Text("تعديل",style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ),
  );

  // Function to add a student to a classroom
  Future<void> deleteReport(String classId, String date) async {
    final docClass = FirebaseFirestore.instance.collection('classrooms').doc(classId);
    final docReport = docClass.collection('classReports').doc(date);

    await docReport.delete().then((_) {
      showSnackBar(context, "تم حذف التقرير بنجاح");
    }).catchError((error) {
      showSnackBar(context, "حدث خطأ أثناء حذف التقرير: $error");
    });

  }
}
