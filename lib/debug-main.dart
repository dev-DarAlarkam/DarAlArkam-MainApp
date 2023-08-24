import 'package:daralarkam_main_app/ui/firebase/new-user/new-user.dart';
import 'package:daralarkam_main_app/ui/widgets/navigate-to-tab-button.dart';
import 'package:flutter/material.dart';
import 'globals/globalColors.dart' as colors;
class Debug extends StatelessWidget {
  const Debug({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: IconThemeData(color: colors.green),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),

    body: Center(
      child: SizedBox(
        width: width*0.9,
        height: height*0.9,
        child: const SingleChildScrollView(
          child: Column(
            children: [
              NavigateToStatefulTabButton(text: "NewUser",icon: "lib/assets/icons/quran.png", nextScreen: NewUserTab()),
              SizedBox(height: 10,),],
            )
          )
        )
      )
    );
  }
}
