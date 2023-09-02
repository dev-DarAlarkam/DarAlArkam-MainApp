import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/firebase/users/get-user.dart';
import 'package:daralarkam_main_app/backend/users/users.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:daralarkam_main_app/globals/globalColors.dart' as colors;

import '../../../services/utils/showSnackBar.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key, this.uid}) : super(key: key);
  final uid;
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
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
                            SizedBox(
                              width: width*0.9,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _firebaseActionButton(context, user.id, "admin"),
                                  const SizedBox(height: 10,),
                                  _firebaseActionButton(context, user.id, "teacher"),

                                ],
                              ),
                            ),
                            const SizedBox(height: 10,),
                            SizedBox(
                              width: width*0.9,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _firebaseActionButton(context, user.id, "student"),
                                  const SizedBox(height: 10,),
                                  _firebaseActionButton(context, user.id, "guest"),

                                ],
                              ),
                            )
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
    );
  }
  Widget _firebaseActionButton(BuildContext context, String uid, String type){
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () async {
        final docUser = FirebaseFirestore.instance
            .collection('users')
            .doc(uid);
        await docUser.update({"type" : type})
            .onError((error, stackTrace) {showSnackBar(context, error.toString());
            });
        },

      child: Container(
        height: height*0.1,
        width: width*0.4,
        decoration: BoxDecoration(
          color: colors.green,
          borderRadius: BorderRadiusDirectional.circular(10),
        ),
        child: Center(child: coloredArabicText("make "+type, c: Colors.white)),
      ),
    );
  }
}
