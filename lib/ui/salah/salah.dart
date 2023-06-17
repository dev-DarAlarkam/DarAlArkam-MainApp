import 'dart:convert';
import 'package:daralarkam_main_app/globals/globalColors.dart' as colors;
import 'package:daralarkam_main_app/backend/salah/salah.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SalahTab extends StatefulWidget {
  const SalahTab({Key? key}) : super(key: key);

  @override
  State<SalahTab> createState() => _SalahTabState();
}

class _SalahTabState extends State<SalahTab> {
  List _items = [];
  PrayerTimesDay _day;

  // Fetch content from the json file
  Future<void> readJson() async {
    DateTime now = DateTime.now();
    //todo: change the next line
    final String response = await rootBundle.loadString('assets/sample.json');
    final data = await json.decode(response);
    setState(() {
      _items= data[now.month];
      _day = PrayerTimesDay.fromJson(_items[now.day-1]);
    });
  }
  @override
  void initState() {
    readJson();
    super.initState();
  }
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
      body: Column(
          children: [
            SizedBox(height: height*.1,child: Image.asset("lib/assets/photos/logo.png"),),
            const Expanded(flex:1,child: SizedBox()),
            Container(
              height: height*0.1,
              width: width*0.6,
              decoration: BoxDecoration(color: colors.green, borderRadius: BorderRadius.circular(10)),
              child: boldColoredArabicText(DateTime.now().toString(), c: Colors.white),
            ),
            // Display the data loaded from sample.json
            _items.isNotEmpty
                //todo change it to rows for each prayer
                ? SizedBox()
                : const CircularProgressIndicator(backgroundColor: Colors.green)
          ],
        ),
    );
  }
}