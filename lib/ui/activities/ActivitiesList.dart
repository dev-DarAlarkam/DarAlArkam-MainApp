import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/Activities/Activity.dart';
import 'package:daralarkam_main_app/backend/classReport/classReport.dart';
import 'package:daralarkam_main_app/ui/activities/ActivityViewerWidgets.dart';
import 'package:daralarkam_main_app/ui/activities/activityViewer.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/material.dart';

// Enum to determine the sort order for students' list
enum SortOrder { ascending, descending }

class ActivitiesListTab extends StatefulWidget {
  const ActivitiesListTab({Key? key}) : super(key: key);

  @override
  State<ActivitiesListTab> createState() => _ActivitiesListTabState();
}

class _ActivitiesListTabState extends State<ActivitiesListTab> {
  // Keeps track of the current sort order (ascending by default)
  SortOrder _currentSortOrder = SortOrder.ascending;
  // List to store events data
  List<Activity> events = [];

  // Stream to read activities
  Stream<List<Activity>> readEvents() =>
      FirebaseFirestore.instance
          .collection('activities')
          .snapshots()
          .map((event) => event.docs.map((e) =>
          Activity.fromJson(e.data())).toList());

  // Function to sort events based on their date
  void sortEvents(SortOrder order) {
    if (order == SortOrder.ascending) {
      events.sort((a, b) => a.date.compareTo(b.date));
    } else {
      events.sort((a, b) => b.date.compareTo(a.date));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("الفعاليات"),
          actions: [
            // Sort button in the app bar
            IconButton(
              icon: Icon(Icons.sort),
              onPressed: () {
                // Toggle the sort order and update the list
                final newOrder = _currentSortOrder == SortOrder.ascending
                    ? SortOrder.descending
                    : SortOrder.ascending;
                sortEvents(newOrder);
                setState(() {
                  _currentSortOrder = newOrder;
                });
              },
            )
          ],
        ),
        body: Center(
          child: StreamBuilder(
            stream: readEvents(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else if (snapshot.hasData) {
                events = snapshot.data as List<Activity>;
                sortEvents(_currentSortOrder);
                return Center(
                  child: ListView(
                    children: events.map(buildEvent).toList(),
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


  Widget buildEvent(Activity activity){
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ActivityViewer(activity: activity,)));
            },
            child: Container(
              height: height * 0.2,
              width: width *0.9,
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: const Offset(0, 6)
                )]
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: width*0.9,
                      height: height*0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: buildThumbnail(activity.thumbnail),
                      clipBehavior: Clip.antiAlias,
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    height: height * 0.1,
                    width: width*0.9,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95), borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        boldColoredArabicText(activity.title),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(activity.date),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),        
        ],
      ),
    );
  }
}
