import 'package:auto_size_text/auto_size_text.dart';
import 'package:DarAlarkam/ui/widgets/my-flutter-app-icons.dart';
import 'package:DarAlarkam/ui/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DarAlarkam/globals/globalColors.dart' as colors;
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:DarAlarkam/ui/widgets/designs.dart';


class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  const Expanded(flex:2,child: SizedBox()),
                  SizedBox(height: height*.1,child: Image.asset("lib/assets/photos/main-logo.png"),),
                  const Expanded(flex:1,child: SizedBox()),
                  Container(
                  height: height*.4,
                  width: width*0.8,
                  decoration: BoxDecoration(
                      color: colors.green,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: Shadow()
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                          height: 0.1*height,
                          width: width*0.7,
                          child: boldColoredArabicText(
                              "مؤسسة تهتم بتحفيظ القران الكريم والتربية الاسلامية في قرية الفريديس",
                              c: Colors.white,
                            maxLines: 4
                          ),
                        ),
                        SizedBox(
                          width: width*0.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              links(MyFlutterApp.facebook, "@Dar9Alarkam",
                                  "https://www.facebook.com/dar9alarkam"),
                              const SizedBox(height: 10),
                              links(MyFlutterApp.instagram, "@Dar9Alarkam",
                                  "https://instagram.com/dar9alarkam"),
                              const SizedBox(height: 10),
                              links(MyFlutterApp.whatsapp, "+972 534308754",
                                  "https://wa.me/message/AVCZWBMNXLBQK1"),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  ),
                  const Expanded(flex:2,child: SizedBox()),
                ]
          ),
        )
    );
  }

  Widget links(IconData icon, String text, String url) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 40, color: Colors.white),
        const SizedBox(
          width: 10,
        ),
        InkWell(
          child: AutoSizeText(
            text,
            style: TextStyle(color: Colors.white, fontFamily: 'kb',),
            minFontSize: 18,

          ),
          onTap: () => _launchURL(url),
        )
      ],
    );
  }
}

_launchURL(String url) async {
  launchUrl(
    Uri.parse(url),
    mode: LaunchMode.externalApplication,
  );
}