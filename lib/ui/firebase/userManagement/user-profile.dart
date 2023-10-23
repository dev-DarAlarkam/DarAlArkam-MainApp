import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daralarkam_main_app/backend/firebase/users/usersUtils.dart';
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
                future: readUser(uid),
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
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  _firebaseActionButton(context, user.id, "admin"),
                                  const SizedBox(height: 10,),
                                  _firebaseActionButton(context, user.id, "teacher"),
                                  const SizedBox(height: 10,),
                                  _firebaseActionButton(context, user.id, "student"),
                                  const SizedBox(height: 10,),
                                  _firebaseActionButton(context, user.id, "guest"),
                                  const SizedBox(height: 10,),
                                  _deleteUserButton(context, uid, user.type)
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
  Widget _firebaseActionButton(BuildContext context, String uid, String type){
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () async {updateUser(context, uid, type);},

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
  
  Widget _deleteUserButton(BuildContext context, String uid, String type){
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () async {
        //todo: remove student from classroom
        final docUser = FirebaseFirestore.instance
            .collection('users')
            .doc(uid);
        await docUser.delete();
        Navigator.pop(context);
      },

      child: Container(
        height: height*0.1,
        width: width*0.4,
        decoration: BoxDecoration(
          color: colors.green,
          borderRadius: BorderRadiusDirectional.circular(10),
        ),
        child: Center(child: coloredArabicText("delete user", c: Colors.white)),
      ),
    );
  }

  Future<void> updateUser(BuildContext context, String uid, String newType) async {
    final docUser = FirebaseFirestore.instance
        .collection('users')
        .doc(uid);
    
    switch (newType) {
      case "student" :
        await docUser.update({"type" : newType})
            .onError((error, stackTrace) {showSnackBar(context, error.toString());});
        await docUser.update({"classId" : ""})
            .onError((error, stackTrace) {showSnackBar(context, error.toString());});
        break;
        
      case "teacher" :
        await docUser.update({"type" : newType})
            .onError((error, stackTrace) {showSnackBar(context, error.toString());});
        await docUser.update({"classIds" : {}})
            .onError((error, stackTrace) {showSnackBar(context, error.toString());});
        break;
      
      default :
        await docUser.update({"type" : newType})
            .onError((error, stackTrace) {showSnackBar(context, error.toString());});
    }

    //exiting the tab after executing the switch
    Navigator.pop(context);

  }

}
