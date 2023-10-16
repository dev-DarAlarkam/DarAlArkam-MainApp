import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/classroom/classroom.dart';
import 'package:daralarkam_main_app/backend/firebase/users/get-user.dart';
import 'package:daralarkam_main_app/backend/users/users.dart';
import 'package:daralarkam_main_app/ui/firebase/admin/user-profile.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/material.dart';

class ClassroomsTab extends StatefulWidget {
  const ClassroomsTab({Key? key}) : super(key: key);

  @override
  State<ClassroomsTab> createState() => _ClassroomsTabState();
}

class _ClassroomsTabState extends State<ClassroomsTab> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: boldColoredArabicText("مجموعاتك"),),
          body:  Center(
            child: StreamBuilder(
              stream: readClassrooms(),
              builder: (context, snapshot) {
                if (snapshot.hasError){return Text(snapshot.error.toString());}
                else if(snapshot.hasData) {
                  final List<Classroom> classrooms = snapshot.data as List<Classroom>;
                  return Center(
                    child: ListView(
                      children: classrooms.map(buildClassroom).toList(),
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
  Stream<List<Classroom>> readClassrooms() => FirebaseFirestore.instance
      .collection('classrooms')
      .where('teacherId', isEqualTo: getUserId()) // Add your filtering condition here
      .snapshots()
      .map((event) => event.docs
      .map((e) => Classroom.fromJson(e.data()))
      .toList());


  Widget buildClassroom(Classroom classroom) => ListTile(
    title: Text(classroom.title),
    subtitle: Text("الصف ${classroom.grade}"),
    onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> UserProfile(uid:user.id)));
    },
  );

}
