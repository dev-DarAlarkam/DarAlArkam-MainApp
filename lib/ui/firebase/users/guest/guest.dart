import 'dart:core';
import 'package:daralarkam_main_app/services/utils/showSnackBar.dart';
import 'package:daralarkam_main_app/ui/home/home.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../backend/userManagement/firebaseUserMethods.dart';
import '../../../../backend/userManagement/firebaseUserUtils.dart';
import '../../../../backend/users/users.dart';
import '../../../../services/firebaseAuthMethods.dart';


class GuestTab extends StatelessWidget {
  const GuestTab({Key? key}) : super(key: key);

  // Function to get the user's first name
  String getUserFirstName(FirebaseUser user) => user.firstName;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar:AppBar(

          // Back Button theme
          iconTheme: const IconThemeData(
              color: Colors.white, //change your color here
            ),
            actions: [

              //Sign-out button
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  signOut(context);
                },
              ),
            ], //for hiding the shadows
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10,),

                // Logo
                SizedBox(height: height*.1,child: Image.asset("lib/assets/photos/logo.png"),),
                const SizedBox(height: 10,),

                //Getting user info to show a greeting message
                FutureBuilder(
                  future: FirebaseUserMethods(getCurrentUserId()).fetchUserFromFirestore(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError){return Text(snapshot.error.toString());}
                    else if(snapshot.hasData) {
                      final dynamic user = snapshot.data!;

                      //greeting message
                      return coloredArabicText("السلام عليكم" +" "+ getUserFirstName(user));
                    }
                    else{return coloredArabicText("يتم التحميل...");}
                  },
                ),
                const SizedBox(height: 10,),

                //A special message for the 'guest' type
                coloredArabicText("سيتم إضافتك لمجموعة قريباً"),
                const Expanded(flex:2,child: SizedBox()),
              ],
            ),
          )
      ),
    );
  }
}