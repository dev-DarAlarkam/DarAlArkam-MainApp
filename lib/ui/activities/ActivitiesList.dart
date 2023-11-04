import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/Activities/Activity.dart';
import 'package:daralarkam_main_app/backend/classReport/classReport.dart';
import 'package:daralarkam_main_app/ui/activities/activityViewer.dart';
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
                print("hi)");
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
    return Stack(
      children: [
        Positioned()
      ],
    )
  }

//   // Build a list tile for a student
//   Widget buildEvent(Activity activity) => ListTile(
//     title: Text(activity.title),
//     onTap: () {
//       Navigator.push(context, MaterialPageRoute(builder: (context)=> ActivityViewer(activity: activity)));
//     },
//   );
}
