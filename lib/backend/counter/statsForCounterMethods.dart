import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/counter/statsForCounter.dart';
import 'package:flutter/material.dart';

/// A utility class for handling statistical data related to counters.
class StatsForCounterMethods {
  /// The id of the user associated with the statistical data.
  final String uid;

  /// List to store individual counter statistics.
  List<int> stats = [];

  /// List to store individual bar chart data points.
  List<Data> barData = [];

  /// List to store weekly sets of bar chart data.
  List<List<Data>> barDataWeeklyList = [];

  /// The total number of counters recorded.
  int numOfCounters = 0;

  /// The highest recorded counter value.
  int highestMark = 0;

  /// The average counter value.
  double average = 0;

  /// Constructs a [StatsForCounterMethods] instance with the specified user identifier.
  StatsForCounterMethods(this.uid);

  /// Fetches statistical data from Firestore and returns a [StatsForCounter] object.
  ///
  /// Returns null if no statistical data is found.
  Future<StatsForCounter?> fetchStatsFromFirestore() async {
    final countersCollection =
    FirebaseFirestore.instance.collection("users").doc(uid).collection('counter');

    QuerySnapshot querySnapshot = await countersCollection.get();
    if (querySnapshot != null) {
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      _splitData(documents);
      numOfCounters = documents.length;
      average = _countAverage();
      highestMark = _findHighestNumber();

      return StatsForCounter(
        stats: stats,
        weeklyData: barDataWeeklyList,
        numOfCounters: numOfCounters,
        average: average,
        highestMark: highestMark,
      );
    } else {
      return null;
    }
  }

  /// Splits the fetched data into individual counter statistics and bar chart data.
  void _splitData(List<QueryDocumentSnapshot> documents) {
    const int daysOfTheWeek = 7;
    int index = 0;
    int length = documents.length;
    int id = 0;

    for (QueryDocumentSnapshot document in documents.reversed) {
      if (document.data() != null) {
        stats.add(document['stat']);
        id = (length - index) % daysOfTheWeek;
        barData.add(
          Data(
            id: id,
            name: document['date'],
            y: document['stat'],
            color: const Color.fromRGBO(15, 148, 71, 1),
          ),
        );
        index++;
        if (barData.length % daysOfTheWeek == 0) {
          barDataWeeklyList.add(barData);
          barData = [];
        }
      }
    }
    if (barData.isNotEmpty) {
      barDataWeeklyList.add(barData);
    }
  }

  /// Calculates the average value of the recorded counter statistics.
  double _countAverage() {
    int sum = 0;
    for (int item in stats) {
      sum += item;
    }
    return sum / stats.length;
  }

  /// Finds the highest recorded counter value.
  int _findHighestNumber() {
    int max = 0;
    for (int item in stats) {
      if (item > max) {
        max = item;
      }
    }
    return max;
  }
}
