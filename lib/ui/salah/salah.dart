import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:daralarkam_main_app/globals/globalColors.dart' as colors;
import '../../backend/salah/salah.dart';

class SalahTab extends StatelessWidget {
  const SalahTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
      return FutureBuilder<Map<String, String>>(
        future: parseXml(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final prayerTimes = snapshot.data;
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
                    SizedBox(height: height*.1,child: Image.asset("lib/assets/photos/main-logo.png"),),
                    const Expanded(flex:1,child: SizedBox()),
                    salahRow("الفجر", prayerTimes!['Fajr']!, context),
                    const SizedBox(height: 10,),
                    salahRow("الشروق", prayerTimes['Shuruq']!, context),
                    const SizedBox(height: 10,),
                    salahRow("الظهر", prayerTimes['Duhr']!, context),
                    const SizedBox(height: 10,),
                    salahRow("العصر", prayerTimes['Asr']!, context),
                    const SizedBox(height: 10,),
                    salahRow("المغرب", prayerTimes['Maghrib']!, context),
                    const SizedBox(height: 10,),
                    salahRow("العشاء", prayerTimes['Isha']!, context),
                    const Expanded(flex:3,child: SizedBox()),
                  ],
                ),
              ),
            );
          } else {
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
                    SizedBox(height: height*.1,child: Image.asset("lib/assets/photos/main-logo.png"),),
                    const Expanded(flex:1,child: SizedBox()),
                    coloredArabicText("Error 404"),
                    const Expanded(flex:2,child: SizedBox()),
                  ],
                ),
              ),
            );
          }
        },
      );
    }
}
Row salahRow(String name, String time, BuildContext context){
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;

  return Row(
    children: [
      const Expanded(flex:1,child: SizedBox()),
      Container(
        height: height*0.05,
        width: width*0.4,
        decoration: BoxDecoration(
          color: colors.green,
          borderRadius: BorderRadiusDirectional.circular(10),
        ),
        child: coloredArabicText(name, c: Colors.white)
      ),
      const Expanded(flex:1,child: SizedBox()),
      Container(
          height: height*0.05,
          width: width*0.4,
          decoration: BoxDecoration(
            color: colors.green,
            borderRadius: BorderRadiusDirectional.circular(10),
          ),
          child: coloredArabicText(time, c: Colors.white)
      ),
      const Expanded(flex:1,child: SizedBox()),
    ],
  );
}