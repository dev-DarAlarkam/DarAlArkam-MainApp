import 'package:daralarkam_main_app/ui/widgets/my-flutter-app-icons.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:daralarkam_main_app/backend/dhekr/dhekrViewer.dart' as adhkar;
import 'package:daralarkam_main_app/backend/dhekr/adhkar.dart' as txt;
import 'package:daralarkam_main_app/globals/globalColors.dart' as color;

//todo: change to text to AutoSizeText
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
          extendBodyBehindAppBar: true,
          appBar:AppBar(
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
                SizedBox(height: height*.02,),
                SizedBox(
                    height: height*0.08,
                    child: Center(child: GreenArabicTextBold("المأثورات"))
                ),
                SizedBox(height: height*.01,),
                SizedBox(
                  height: height*0.5,
                  width: width*.95,
                  child: Center(child:ColoredArabicText(Colors.black, block.current()[0])),
                ),
                SizedBox(height: height*0.01,),
                SizedBox(height: height*0.1,child: ColoredArabicText(Colors.red, block.current()[1])),
                SizedBox(height: height*.05,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton.icon(
                        onPressed: _next,
                        icon: Icon(
                          MyFlutterApp.arrow_alt_circle_left,
                          color: color.green,
                        ),
                        label: GreenArabicText("التالي")
                    ),
                      TextButton.icon(
                          onPressed: _previous,
                          icon: Icon(
                            MyFlutterApp.arrow_alt_circle_right,
                            color: color.green,
                          ),
                          label: GreenArabicText("السابق")
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
