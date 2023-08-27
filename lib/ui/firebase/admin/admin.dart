import 'dart:core';
import 'package:daralarkam_main_app/backend/firebase/users/get-user.dart';
import 'package:daralarkam_main_app/ui/firebase/admin/users-tab.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:daralarkam_main_app/globals/globalColors.dart' as colors;

import '../../../backend/users/user.dart';
import '../../widgets/navigate-to-tab-button.dart';


class AdminTab extends StatelessWidget {
  const AdminTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar:AppBar(
          iconTheme: IconThemeData(
            color: colors.green, //change your color here
          ),
          backgroundColor: Colors.transparent, //for hiding the appBar
          elevation: 0, //for hiding the shadows
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height*.1,child: Image.asset("lib/assets/photos/logo.png"),),
              const Expanded(flex:1,child: SizedBox()),
              FutureBuilder(
                future: readUser(context, getUserId()),
                builder: (context, snapshot) {
                  if (snapshot.hasError){return Text(snapshot.error.toString());}
                  else if(snapshot.hasData) {
                    final dynamic user = snapshot.data!;
                    return coloredArabicText("السلام عليكم" +" "+ getUserFirstName(user));
                  }
                  else{return const Center(child: CircularProgressIndicator());}
                },
              ),
              const Expanded(flex:1,child: SizedBox()),
              const SingleChildScrollView(
                child: Column(
                  children: [
                    NavigateToStatefulTabButton(text: "users",icon: "lib/assets/icons/salat.png", nextScreen: UsersTab()),
                  ]
                ),
              ),
              const Expanded(flex:2,child: SizedBox()),
            ],
          ),
        )
    );
  }
  String getUserFirstName(FirebaseUser user) => user.firstName;
}