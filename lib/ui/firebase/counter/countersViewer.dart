import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:DarAlarkam/backend/users/users.dart';
import 'package:DarAlarkam/ui/firebase/admin/user-profile.dart';
import 'package:DarAlarkam/ui/firebase/counter/counterScreenRead.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../backend/counter/counter.dart';
import '../../widgets/text.dart';

class CountersViewer extends StatefulWidget {
  const CountersViewer({Key? key}) : super(key: key);

  @override
  State<CountersViewer> createState() => _CountersViewerState();
}

class _CountersViewerState extends State<CountersViewer> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: coloredArabicText('برنامج المحاسبة - الأيام السابقة', c:Colors.white),
          ),
          body:  Center(
            child: StreamBuilder(
              stream: readCounters(),
              builder: (context, snapshot) {
                if (snapshot.hasError){return Text(snapshot.error.toString());}
                else if(snapshot.hasData) {
                  final List<Counter> counters = snapshot.data as List<Counter>;
                  return Center(
                    child: ListView(
                      children: counters.map(buildCounter).toList(),
                    ),
                  );
                }
                else{return const Center(child: CircularProgressIndicator());}
              },
            ),
          ),
        )
    );
  }
  Stream<List<Counter>> readCounters() {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('counter')
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Counter.fromJson(e.data())).toList());
  }

  Widget buildCounter(Counter counter) => ListTile(
    title: Text(counter.date),
    onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> CounterScreenRead(counter: counter)));
    },
  );

}
