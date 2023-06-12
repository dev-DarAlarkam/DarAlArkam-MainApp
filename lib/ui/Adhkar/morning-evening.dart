import 'package:daralarkam_main_app/ui/widgets/my-flutter-app-icons.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:daralarkam_main_app/backend/dhekr/dhekrViewer.dart' as adhkar;
import 'package:daralarkam_main_app/backend/dhekr/adhkar.dart' as txt;
import 'package:daralarkam_main_app/globals/globalColors.dart' as colors;

class MorningEvening extends StatefulWidget {
  const MorningEvening({Key? key}) : super(key: key);

  @override
  _MorningEveningState createState() => _MorningEveningState();
}

class _MorningEveningState extends State<MorningEvening> {

  _MorningEveningState();
  adhkar.Viewer block = adhkar.Viewer(
      txt.morningEvening.keys.toList(),
      txt.morningEvening.values.toList()
  );
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;


    return Scaffold(
          appBar:AppBar(
            iconTheme: IconThemeData(
              color: colors.green, //change your color here
            ),
            backgroundColor: Colors.transparent, //for hiding the appBar
            elevation: 0, //for hiding the shadows
          ),
          body: Container(
            height: height,
            width: width,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                boldColoredArabicText("المأثورات", c:colors.green,minSize: 40, maxSize: 40),
                Expanded(child: SizedBox()),
                SizedBox(
                  height: height*0.55,
                  width: width*.95,
                  child:Center(
                    child: SingleChildScrollView(
                      child: coloredArabicText(block.current()[0], c: Colors.black, maxLines: 20,minSize: 25, maxSize: 40),
                      physics: const ClampingScrollPhysics(),
                    ),
                  ),
                ),
                Expanded(child: SizedBox()),
                coloredArabicText(block.current()[1], c: Colors.red),
                Expanded(child: SizedBox()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton.icon(
                        onPressed: _next,
                        icon: Icon(
                          MyFlutterApp.arrow_alt_circle_left,
                          color: colors.green,
                        ),
                        label: coloredArabicText("التالي", c:colors.green)
                    ),
                      TextButton.icon(
                          onPressed: _previous,
                          icon: Icon(
                            MyFlutterApp.arrow_alt_circle_right,
                            color: colors.green,
                          ),
                          label: coloredArabicText("السابق", c: colors.green)
                      )
                  ]
              ),
              ],
            )
        )
    );
  }
  void _next()
  {
      setState(()
      {
        block.next();
      }
      );
  }
  void _previous()
  {
    setState(()
    {
      block.previous();
    }
    );
  }
}
