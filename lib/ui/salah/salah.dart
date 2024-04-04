import 'package:daralarkam_main_app/ui/salah/salahWidgets.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:daralarkam_main_app/globals/globalColors.dart' as colors;
import '../../backend/salah/salah.dart';


class SalahTab extends StatefulWidget {
  const SalahTab({Key? key}) : super(key: key);
  @override
  State<SalahTab> createState() => _SalahTabState();
}

class _SalahTabState extends State<SalahTab> {
  bool isDst = false;
  DateTime chosenDate = DateTime.now();
  Map<String, dynamic> salahNotificationIndicators = {
    "Fajr" : false,
    "Shuruq" : false,
    "Duhr" : false,
    "Asr" : false,
    "Maghrib" : false,
    "Isha" : false
  };

  @override
  void initState() {

    Future<bool> futureIsDst = readDSTStatus();
    futureIsDst.then((value) {
      isDst = value;
    });

    Future<Map<String,dynamic>> futureSalahNotificationIndicators = readSalahNotificationStatus();
    futureSalahNotificationIndicators.then((value) {
      salahNotificationIndicators = value;
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

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
                future: parseXml(chosenDate),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData) {

                    final prayerTimes = snapshot.data!;
                    return Center(
                      child: SizedBox(
                        height: height*0.7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Expanded(flex:1,child: SizedBox()),
                            SizedBox(height: height*.1,child: Image.asset("lib/assets/photos/main-logo.png"),),
                            const Expanded(flex:4,child: SizedBox()),
                            dateRows(context, chosenDate),
                            const SizedBox(height: 10,),

                            //Fajr
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Expanded(flex:1,child: SizedBox()),
                                Container(
                                    height: height*0.05,
                                    width: width*0.3,
                                    decoration: BoxDecoration(
                                      color: colors.green,
                                      borderRadius: BorderRadiusDirectional.circular(10),
                                    ),
                                    child: Center(child: coloredArabicText("الفجر", c: Colors.white))
                                ),
                                const Expanded(flex:1,child: SizedBox()),
                                Container(
                                    height: height*0.05,
                                    width: width*0.2,
                                    decoration: BoxDecoration(
                                      color: colors.green,
                                      borderRadius: BorderRadiusDirectional.circular(10),
                                    ),
                                    child: Center(child: coloredArabicText(adjustTimeForDST(prayerTimes['Fajr']!, isDst), c: Colors.white))
                                ),
                                const Expanded(flex:1,child: SizedBox()),
                                IconButton(
                                    onPressed: (){
                                      salahNotificationIndicators['Fajr'] = salahNotificationIndicators['Fajr'] ? false : true;
                                      setState(() {});
                                    },
                                    icon: (salahNotificationIndicators["Fajr"]) ? Icon(CupertinoIcons.speaker_2) : Icon(CupertinoIcons.speaker_slash)),

                                const Expanded(flex:1,child: SizedBox()),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            //Shuruq
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Expanded(flex:1,child: SizedBox()),
                                Container(
                                    height: height*0.05,
                                    width: width*0.3,
                                    decoration: BoxDecoration(
                                      color: colors.green,
                                      borderRadius: BorderRadiusDirectional.circular(10),
                                    ),
                                    child: Center(child: coloredArabicText("الشروق", c: Colors.white))
                                ),
                                const Expanded(flex:1,child: SizedBox()),
                                Container(
                                    height: height*0.05,
                                    width: width*0.2,
                                    decoration: BoxDecoration(
                                      color: colors.green,
                                      borderRadius: BorderRadiusDirectional.circular(10),
                                    ),
                                    child: Center(child: coloredArabicText(adjustTimeForDST(prayerTimes!['Shuruq']!, isDst), c: Colors.white))
                                ),
                                const Expanded(flex:1,child: SizedBox()),
                                IconButton(
                                    onPressed: (){
                                      salahNotificationIndicators['Shuruq'] = salahNotificationIndicators['Shuruq'] ? false : true;
                                      setState(() {});
                                    },
                                    icon: (salahNotificationIndicators["Shuruq"]) ? Icon(CupertinoIcons.speaker_2) : Icon(CupertinoIcons.speaker_slash)),

                                const Expanded(flex:1,child: SizedBox()),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            //Duhr
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Expanded(flex:1,child: SizedBox()),
                                Container(
                                    height: height*0.05,
                                    width: width*0.3,
                                    decoration: BoxDecoration(
                                      color: colors.green,
                                      borderRadius: BorderRadiusDirectional.circular(10),
                                    ),
                                    child: Center(child: coloredArabicText("الظهر", c: Colors.white))
                                ),
                                const Expanded(flex:1,child: SizedBox()),
                                Container(
                                    height: height*0.05,
                                    width: width*0.2,
                                    decoration: BoxDecoration(
                                      color: colors.green,
                                      borderRadius: BorderRadiusDirectional.circular(10),
                                    ),
                                    child: Center(child: coloredArabicText(adjustTimeForDST(prayerTimes!['Duhr']!, isDst), c: Colors.white))
                                ),
                                const Expanded(flex:1,child: SizedBox()),
                                IconButton(
                                    onPressed: (){
                                      salahNotificationIndicators['Duhr'] = salahNotificationIndicators['Duhr'] ? false : true;
                                      setState(() {});
                                    },
                                    icon: (salahNotificationIndicators["Duhr"]) ? Icon(CupertinoIcons.speaker_2) : Icon(CupertinoIcons.speaker_slash)),

                                const Expanded(flex:1,child: SizedBox()),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            //Asr
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Expanded(flex:1,child: SizedBox()),
                                Container(
                                    height: height*0.05,
                                    width: width*0.3,
                                    decoration: BoxDecoration(
                                      color: colors.green,
                                      borderRadius: BorderRadiusDirectional.circular(10),
                                    ),
                                    child: Center(child: coloredArabicText("العصر", c: Colors.white))
                                ),
                                const Expanded(flex:1,child: SizedBox()),
                                Container(
                                    height: height*0.05,
                                    width: width*0.2,
                                    decoration: BoxDecoration(
                                      color: colors.green,
                                      borderRadius: BorderRadiusDirectional.circular(10),
                                    ),
                                    child: Center(child: coloredArabicText(adjustTimeForDST(prayerTimes!['Asr']!, isDst), c: Colors.white))
                                ),
                                const Expanded(flex:1,child: SizedBox()),
                                IconButton(
                                    onPressed: (){
                                      salahNotificationIndicators['Asr'] = salahNotificationIndicators['Asr'] ? false : true;
                                      setState(() {});
                                    },
                                    icon: (salahNotificationIndicators["Asr"]) ? Icon(CupertinoIcons.speaker_2) : Icon(CupertinoIcons.speaker_slash)),

                                const Expanded(flex:1,child: SizedBox()),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            //Maghrib
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Expanded(flex:1,child: SizedBox()),
                                Container(
                                    height: height*0.05,
                                    width: width*0.3,
                                    decoration: BoxDecoration(
                                      color: colors.green,
                                      borderRadius: BorderRadiusDirectional.circular(10),
                                    ),
                                    child: Center(child: coloredArabicText("المغرب", c: Colors.white))
                                ),
                                const Expanded(flex:1,child: SizedBox()),
                                Container(
                                    height: height*0.05,
                                    width: width*0.2,
                                    decoration: BoxDecoration(
                                      color: colors.green,
                                      borderRadius: BorderRadiusDirectional.circular(10),
                                    ),
                                    child: Center(child: coloredArabicText(adjustTimeForDST(prayerTimes!['Maghrib']!, isDst), c: Colors.white))
                                ),
                                const Expanded(flex:1,child: SizedBox()),
                                IconButton(
                                    onPressed: (){
                                      salahNotificationIndicators['Maghrib'] = salahNotificationIndicators['Maghrib'] ? false : true;
                                      setState(() {});
                                    },
                                    icon: (salahNotificationIndicators["Maghrib"]) ? Icon(CupertinoIcons.speaker_2) : Icon(CupertinoIcons.speaker_slash)),

                                const Expanded(flex:1,child: SizedBox()),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            //Isha
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Expanded(flex:1,child: SizedBox()),
                                Container(
                                    height: height*0.05,
                                    width: width*0.3,
                                    decoration: BoxDecoration(
                                      color: colors.green,
                                      borderRadius: BorderRadiusDirectional.circular(10),
                                    ),
                                    child: Center(child: coloredArabicText("العشاء", c: Colors.white))
                                ),
                                const Expanded(flex:1,child: SizedBox()),
                                Container(
                                    height: height*0.05,
                                    width: width*0.2,
                                    decoration: BoxDecoration(
                                      color: colors.green,
                                      borderRadius: BorderRadiusDirectional.circular(10),
                                    ),
                                    child: Center(child: coloredArabicText(adjustTimeForDST(prayerTimes!['Isha']!, isDst), c: Colors.white))
                                ),
                                const Expanded(flex:1,child: SizedBox()),
                                IconButton(
                                    onPressed: (){
                                      salahNotificationIndicators['Isha'] = salahNotificationIndicators['Isha'] ? false : true;
                                      setState(() {});
                                    },
                                    icon: (salahNotificationIndicators["Isha"]) ? Icon(CupertinoIcons.speaker_2) : Icon(CupertinoIcons.speaker_slash)),

                                const Expanded(flex:1,child: SizedBox()),
                              ],
                            ),
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
                    isDst ? 'توقيت صيفي' : 'توقيت شتوي', c: Colors.white),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: _changeDateToYesterday,
                      icon: Icon(Icons.arrow_back_ios,color: colors.green)
                  ),

                  _compareDates(chosenDate, DateTime.now())
                      ? const  SizedBox(width:10)
                      : ElevatedButton(
                    onPressed: _changeDateToToToday,
                    child: coloredArabicText("اليوم", c: Colors.white),
                  ),
                  IconButton(
                    onPressed: _changeDateToTomorrow,
                    icon: Icon(Icons.arrow_forward_ios,color: colors.green),
                  )
                ],
              ),
              const SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
  void _toggleDST() {
    updateDstStatus(isDst).then((value) {
      Future<bool> futureIsDst = readDSTStatus();
      futureIsDst.then((value) {
        isDst = value;
        setState(() {});
      });
    });
  }
  void _changeDateToToToday() {
    setState(() {
      chosenDate = DateTime.now();
    });
  }
  void _changeDateToTomorrow() {
    setState(() {
      chosenDate = chosenDate.add(Duration(days: 1));
    });
  }
  void _changeDateToYesterday() {
    setState(() {
      chosenDate = chosenDate.subtract(Duration(days: 1));
    });
  }
  bool _compareDates(DateTime firstDate, DateTime secondDate) {
    return firstDate.month == secondDate.month
    && firstDate.day == secondDate.day;
  }

}




