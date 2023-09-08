import 'package:DarAlarkam/ui/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:DarAlarkam/globals/globalColors.dart' as colors;
import '../../backend/salah/hijri-date.dart';
import '../../backend/salah/salah.dart';

class Salah extends StatefulWidget {
  const Salah({Key? key}) : super(key: key);

  @override
  State<Salah> createState() => _SalahState();
}

class _SalahState extends State<Salah> {
  bool _isDST = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
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
                          salahRow("الفجر", adjustTimeForDST(prayerTimes!['Fajr']!, _isDST), context),
                          const SizedBox(height: 10,),
                          salahRow("الشروق", adjustTimeForDST(prayerTimes['Shuruq']!, _isDST), context),
                          const SizedBox(height: 10,),
                          salahRow("الظهر", adjustTimeForDST(prayerTimes['Duhr']!, _isDST), context),
                          const SizedBox(height: 10,),
                          salahRow("العصر", adjustTimeForDST(prayerTimes['Asr']!, _isDST), context),
                          const SizedBox(height: 10,),
                          salahRow("المغرب", adjustTimeForDST(prayerTimes['Maghrib']!, _isDST), context),
                          const SizedBox(height: 10,),
                          salahRow("العشاء", adjustTimeForDST(prayerTimes['Isha']!, _isDST), context),
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
                  _isDST ? 'توقيت صيفي' : 'توقيت شتوي', c: Colors.white),
            ),
            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
  void _toggleDST() {
    setState(() {
      _isDST = !_isDST;
    });
  }
}

Widget salahRow(String name, String time, BuildContext context){
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;

  return Directionality(
    textDirection: TextDirection.rtl,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(flex:1,child: SizedBox()),
        Container(
            height: height*0.05,
            width: width*0.4,
            decoration: BoxDecoration(
              color: colors.green,
              borderRadius: BorderRadiusDirectional.circular(10),
            ),
            child: Center(child: coloredArabicText(name, c: Colors.white))
        ),
        const Expanded(flex:1,child: SizedBox()),
        Container(
            height: height*0.05,
            width: width*0.3,
            decoration: BoxDecoration(
              color: colors.green,
              borderRadius: BorderRadiusDirectional.circular(10),
            ),
            child: Center(child: coloredArabicText(time, c: Colors.white))
        ),
        const Expanded(flex:1,child: SizedBox()),
      ],
    ),
  );
}

Widget dateRow(BuildContext context){
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;

  return Directionality(
    textDirection: TextDirection.rtl,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            height: height*0.05,
            width: width*0.6,
            decoration: BoxDecoration(
              color: colors.green,
              borderRadius: BorderRadiusDirectional.circular(10),
            ),
            child: Center(child: coloredArabicText(getTodayDateH(), c: Colors.white))
        ),
      ],
    ),
  );
}


String adjustTimeForDST(String timeStr, bool isDST) {
  final timeParts = timeStr.split(":");
  if (timeParts.length == 2) {
    final hour = int.tryParse(timeParts[0]);
    final minute = int.tryParse(timeParts[1]);

    if (hour != null && minute != null) {
      if (isDST) {
        final now = DateTime.now();
        final dstStartDate = DateTime(now.year, 3, 31 - (now.weekday - DateTime.sunday) % 7, 2); // DST starts on the last Sunday of March at 2 AM
        final dstEndDate = DateTime(now.year, 10, 31 - (now.weekday - DateTime.sunday) % 7, 2); // DST ends on the last Sunday of October at 2 AM

        if (now.isAfter(dstStartDate) && now.isBefore(dstEndDate)) {
          // Add an hour for DST
          final adjustedHour = (hour + 1) % 24;
          return "${adjustedHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
        }
      }

      // If not DST or DST adjustment not needed, return the original time
      return "$hour:${minute.toString().padLeft(2, '0')}";
    }
  }

  // Return the input time if parsing failed
  return timeStr;
}
