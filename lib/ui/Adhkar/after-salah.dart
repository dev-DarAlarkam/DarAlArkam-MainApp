import 'package:DarAlarkam/ui/widgets/my-flutter-app-icons.dart';
import 'package:DarAlarkam/ui/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DarAlarkam/backend/dhekr/dhekrViewer.dart' as adhkar;
import 'package:DarAlarkam/backend/dhekr/adhkar.dart' as txt;
import 'package:DarAlarkam/globals/globalColors.dart' as colors;

class AfterSalah extends StatefulWidget {
  const AfterSalah({Key? key}) : super(key: key);

  @override
  _AfterSalahState createState() => _AfterSalahState();
}

class _AfterSalahState extends State<AfterSalah> {

  _AfterSalahState();
  adhkar.Viewer block = adhkar.Viewer(
      txt.afterSalah.keys.toList(),
      txt.afterSalah.values.toList()
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
        body:
            GestureDetector(
              onHorizontalDragEnd: (dragDetail) {
                if (dragDetail.velocity.pixelsPerSecond.dx < 0) {
                  _previous();
                } else {
                  _next();
                }
              },
              behavior: HitTestBehavior.translucent,
              child: SizedBox(
                height: height,
                width: width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [boldColoredArabicText("أذكار ما بعد الصلاة", c:colors.green,minSize: 40, maxSize: 40),
                    const Expanded(child: SizedBox()),
                    SizedBox(
                      height: height*0.6,
                      width: width*.95,
                      child:Center(
                        child: SingleChildScrollView(
                          child: coloredArabicText(block.current()[0], c: Colors.black, maxLines: 20,minSize: 30, maxSize: 40),
                          physics: const ClampingScrollPhysics(),
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    SizedBox(
                        width: width*0.95,
                        child: coloredArabicText(block.current()[1],maxLines: 2 ,c: Colors.red)
                    ),
                    const Expanded(child: SizedBox()),
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
                ),
              ),
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
