import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/counter/stats.dart';
import 'package:flutter/material.dart';

class StatsForCounterMethods {
  final String uid;
  Map<String, int> statsWithDate = {};
  List<int> stats = [];
  List<Data> barData = [];
  List<List<Data>> barDataList = [];
  int numOfCounters = 0;
  int highestMark = 0;
  double average = 0;

  StatsForCounterMethods(this.uid);

  Future<StatsForCounter> fetchStatsFromFirestore() async {
    final countersCollection = FirebaseFirestore.instance.collection("users")
        .doc(uid).collection('counter');

    QuerySnapshot querySnapshot = await countersCollection.get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    int index = 0;
    int length = documents.length;
    int id = 0;
    int counter =0;

    for (QueryDocumentSnapshot document in documents.reversed) {
      if(document.data() != null){

        stats.add(document['stat']);
        id = (length - index) % 7;
        barData.add(
            Data(
                id: id,
                name: document['date'],
                y: document['stat'],
                color: const Color.fromRGBO(15,148,71,1)
            )
        );
        index++;
        if(barData.length%7 ==0) {
          barDataList.add(barData);
          barData =[];
        }
      }
    }
    if(barData.isNotEmpty) {
      barDataList.add(barData);
    }
    numOfCounters = documents.length;
    average = countAverage();
    highestMark = findHighestNumber();

    return StatsForCounter(
        stats: stats,
        data: barDataList,
        numOfCounters: numOfCounters,
        average: average,
        highestMark: highestMark
    );
  }

  double countAverage(){
    int sum =0;
    for(int item in stats) {
      sum +=item;
    }
    return sum/stats.length;
  }

  int findHighestNumber() {
    int max = 0;
    for(int item in stats) {
      if (item > max){
        max = item;
      }
    }
    return max;
  }



}