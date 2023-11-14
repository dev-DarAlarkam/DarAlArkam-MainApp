import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/ui/firebase/counter/counterScreenRead.dart';
import 'package:flutter/material.dart';

import '../../../backend/counter/counter.dart';
import '../../widgets/text.dart';
import 'counterScreenEdit.dart';

// Enum to determine the sort order for counters' list
enum SortOrder { ascending, descending }

class CountersViewerWithoutEdit extends StatefulWidget {
  const CountersViewerWithoutEdit({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  State<CountersViewerWithoutEdit> createState() => _CountersViewerWithoutEditState();
}

class _CountersViewerWithoutEditState extends State<CountersViewerWithoutEdit> {
  // Keeps track of the current sort order (ascending by default)
  SortOrder _currentSortOrder = SortOrder.ascending;
  // List to store counters data
  List<Counter> counters = [];

  @override
  void initState() {
    super.initState();
    // Fetch and sort the counters when the widget is initialized
    sortCounters(_currentSortOrder);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: coloredArabicText('برنامج المحاسبة - الأيام السابقة',
              c: Colors.white),
          actions: [
            // Sort button in the app bar
            IconButton(
              icon: Icon(Icons.sort),
              onPressed: () {
                // Toggle the sort order and update the list
                final newOrder = _currentSortOrder == SortOrder.ascending
                    ? SortOrder.descending
                    : SortOrder.ascending;
                sortCounters(newOrder);
                setState(() {
                  _currentSortOrder = newOrder;
                });
              },
            )
          ],
        ),
        body: Center(
          child: StreamBuilder(
            stream: readCounters(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else if (snapshot.hasData) {
                counters = snapshot.data as List<Counter>;
                sortCounters(_currentSortOrder);
                return Center(
                  child: ListView.builder(
                    itemCount: counters.length,
                    itemBuilder: (context, index) =>
                        buildCounter(counters[index]),
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

  Stream<List<Counter>> readCounters() {
    String uid = widget.uid;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('counter')
        .snapshots()
        .map((event) =>
        event.docs.map((e) => Counter.fromJson(e.data())).toList());
  }

  // Function to sort counters based on their date
  void sortCounters(SortOrder order) {
      if (order == SortOrder.ascending) {
        // Sort in ascending order (oldest to newest)
        counters.sort((a, b) => a.date.compareTo(b.date));
      } else {
        // Sort in descending order (newest to oldest)
        counters.sort((a, b) => b.date.compareTo(a.date));
      }
  }

  Widget buildCounter(Counter counter) => ListTile(
    title: Text(counter.date),
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CounterScreenRead(counter: counter)));
    },
  );
}
