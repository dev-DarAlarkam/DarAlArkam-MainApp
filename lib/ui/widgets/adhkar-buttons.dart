import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:daralarkam_main_app/globals/globalColors.dart' as colors;

class NavigateToTabButton extends StatelessWidget {
  final String icon,text;
  final StatefulWidget nextScreen;
  const NavigateToTabButton({Key? key, required this.text, required this.icon, required this.nextScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> nextScreen));
      },
      child: Container(
        height: height*0.1,
        width: width*0.7,
        decoration: BoxDecoration(
          color: colors.green,
          borderRadius: BorderRadiusDirectional.circular(10),
        ),
        child: Row(
          children: [
            Expanded(flex:3,child: SizedBox()),
            boldColoredArabicText(text, c: Colors.white, minSize: 20),
            Expanded(flex:2,child: SizedBox()),
            SizedBox(
                height: height*0.08,
                child: Image.asset(icon,scale: 0.2,)
            ),
            Expanded(flex:1,child: SizedBox())
          ],
        )
      ),
    );
  }
}