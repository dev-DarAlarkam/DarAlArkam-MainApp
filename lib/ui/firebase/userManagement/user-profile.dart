import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/users/users.dart';
import 'package:daralarkam_main_app/ui/firebase/userManagement/userManagementWidgets.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/material.dart';

import '../../../backend/userManagement/usersUtils.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key,required this.uid}) : super(key: key);
  final String uid;
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
                future: readUser(uid),
                builder: (context, snapshot){
                  if(snapshot.hasError){return Text(snapshot.error.toString());}
                  else if (snapshot.hasData) {
                    final FirebaseUser user = snapshot.data as FirebaseUser;
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
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  userTypeChangeButton(context, user.id, user.type, "admin"),
                                  const SizedBox(height: 10,),
                                  userTypeChangeButton(context, user.id, user.type, "teacher"),
                                  const SizedBox(height: 10,),
                                  userTypeChangeButton(context, user.id, user.type, "student"),
                                  const SizedBox(height: 10,),
                                  userTypeChangeButton(context, user.id, user.type, "guest"),
                                  const SizedBox(height: 10,),
                                  deleteUserButton(context, uid, user.type)
                                ],
                              ),
                            ),
                            
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
}