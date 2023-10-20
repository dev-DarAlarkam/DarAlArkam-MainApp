import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/firebase/users/get-user.dart';
import 'package:daralarkam_main_app/backend/users/users.dart';
import 'package:daralarkam_main_app/ui/firebase/counter/countersViewer.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:daralarkam_main_app/globals/globalColors.dart' as colors;

import '../../../services/utils/showSnackBar.dart';

class ShowStudentDetailsTab extends StatelessWidget {
  const ShowStudentDetailsTab({Key? key, required this.uid}) : super(key: key);
  final uid;
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ملف الطالب الشخصي"),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 10,),

              const Icon(Icons.person),
              FutureBuilder(
                  future: readUser(context, uid),
                  builder: (context, snapshot){
                    if(snapshot.hasError){return Text(snapshot.error.toString());}
                    else if (snapshot.hasData) {
                      final dynamic user = snapshot.data;
                      // final user = FirebaseUser.fromJson(userDoc);
                      return Center(
                        child: SizedBox(
                          height: height*0.8,
                          child: Column(
                            children: [
                              //username
                              coloredArabicText(user.firstName + " " + user.secondName + " " + user.thirdName),
                              const SizedBox(height: 10,),
                              //type
                              coloredArabicText(user.type),
                              const SizedBox(height: 10,),
                              //birthday
                              coloredArabicText(user.birthday),
                              const Expanded(child: SizedBox()),
                              //action buttons rows
                              ElevatedButton(onPressed: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CountersViewer(uid: uid,)));
                              }, child: coloredArabicText("برنامج المحاسبة", c: Colors.white))
                            ],
                          ),
                        ),
                      );
                    }
                    else{return const Center(child: CircularProgressIndicator());}

                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
