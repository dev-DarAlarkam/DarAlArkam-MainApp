import 'package:daralarkam_main_app/ui/salah/salahWidgets.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:daralarkam_main_app/globals/globalColors.dart' as colors;
import '../../backend/salah/salah.dart';

bool isDST = false;

class SalahTab extends StatefulWidget {
  const SalahTab({Key? key}) : super(key: key);

  @override
  State<SalahTab> createState() => _SalahTabState();
}

class _SalahTabState extends State<SalahTab> {

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
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
              FutureBuilder<Map<String, String>>(
                future: parseXml(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    final prayerTimes = snapshot.data;

                    return Center(
                      child: SizedBox(
                        height: height*0.7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Expanded(flex:1,child: SizedBox()),
                            SizedBox(height: height*.1,child: Image.asset("lib/assets/photos/main-logo.png"),),
                            const Expanded(flex:4,child: SizedBox()),
                            dateRow(context),
                            const SizedBox(height: 10,),
                            salahRow("الفجر", adjustTimeForDST(prayerTimes!['Fajr']!, isDST), context),
                            const SizedBox(height: 10,),
                            salahRow("الشروق", adjustTimeForDST(prayerTimes['Shuruq']!, isDST), context),
                            const SizedBox(height: 10,),
                            salahRow("الظهر", adjustTimeForDST(prayerTimes['Duhr']!, isDST), context),
                            const SizedBox(height: 10,),
                            salahRow("العصر", adjustTimeForDST(prayerTimes['Asr']!, isDST), context),
                            const SizedBox(height: 10,),
                            salahRow("المغرب", adjustTimeForDST(prayerTimes['Maghrib']!, isDST), context),
                            const SizedBox(height: 10,),
                            salahRow("العشاء", adjustTimeForDST(prayerTimes['Isha']!, isDST), context),
                            const Expanded(flex:3,child: SizedBox()),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Text('Error loading data.');
                  }
                },
              ),
              const Expanded(flex:3,child: SizedBox()),
              ElevatedButton(
                onPressed: _toggleDST,
                child: coloredArabicText(
                    isDST ? 'توقيت صيفي' : 'توقيت شتوي', c: Colors.white),
              ),
              const SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
  void _toggleDST() {
    setState(() {
      isDST = !isDST;
    });
  }
}




