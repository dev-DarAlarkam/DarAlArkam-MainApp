import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:daralarkam_main_app/globals/globalColors.dart' as colors;

class NavigateToStatefulTabButton extends StatelessWidget {
  final String icon,text;
  final StatefulWidget nextScreen;
  const NavigateToStatefulTabButton({Key? key, required this.text, required this.icon, required this.nextScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final int minFont = ((width * 8) ~/ 100);
    final int maxFont = ((width * 10) ~/ 100);


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
            Expanded(flex:2,child: SizedBox()),
            boldColoredArabicText(text, c: Colors.white, minSize: minFont * 1.0, maxSize: maxFont * 1.0),
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

class NavigateToStatelessTabButton extends StatelessWidget {
  final String icon,text;
  final StatelessWidget nextScreen;
  const NavigateToStatelessTabButton({Key? key, required this.text, required this.icon, required this.nextScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final int minFont = ((width * 8) ~/ 100);
    final int maxFont = ((width * 10) ~/ 100);


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
              Expanded(flex:2,child: SizedBox()),
              boldColoredArabicText(text, c: Colors.white, minSize: minFont * 1.0, maxSize: maxFont * 1.0),
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