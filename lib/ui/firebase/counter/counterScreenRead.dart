import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/material.dart';
import '../../../backend/counter/counter.dart'; // Import your Counter class

class CounterScreenRead extends StatefulWidget {
  final Counter counter;

  CounterScreenRead({required this.counter});

  @override
  _CounterScreenReadState createState() => _CounterScreenReadState();
}

class _CounterScreenReadState extends State<CounterScreenRead> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: coloredArabicText('برنامج المحاسبة'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // coloredArabicText('التاريخ: ${widget.counter.date}'),
                const Divider(),
                boldColoredArabicText('الصلوات الخمس'),
                ListTile(
                  title: const Text("صلاة الفجر"),
                  trailing: Text(translateSalahCounterTypes(widget.counter.salah.fajr))
                ),
                ListTile(
                  title: const Text("صلاة الظهر"),
                  trailing: Text(translateSalahCounterTypes(widget.counter.salah.duhr)),
                ),
                ListTile(
                  title: const Text("صلاة العصر"),
                  trailing: Text(translateSalahCounterTypes(widget.counter.salah.asr))
                ),
                ListTile(
                  title: const Text("صلاة المغرب"),
                  trailing: Text(translateSalahCounterTypes(widget.counter.salah.maghrib)),
                ),
                ListTile(
                  title: const Text("صلاة العشاء"),
                  trailing: Text(translateSalahCounterTypes(widget.counter.salah.ishaa)),
                ),

                const Divider(),
                coloredArabicText('النوافل'),
                ListTile(
                  title: const Text('صلاة الضحى'),
                  trailing: Text(translateBool(widget.counter.nawafel.duha)),
                ),
                ListTile(
                  title: const Text('قيام الليل'),
                  trailing: Text(translateBool(widget.counter.nawafel.qiyam)),
                  ),
                ListTile(
                  title: const Text('صيام تطوع'),
                  trailing: Text(translateBool(widget.counter.nawafel.siyam)),
                  ),

                const Divider(),
                coloredArabicText('الأذكار'),
                ListTile(
                  title: const Text('المأثورات'),
                  trailing: Text(translateBool(widget.counter.dhekr.morningEvening)),
                  ),
                ListTile(
                  title: const Text('إستغفار 100 مرة'),
                  trailing: Text(translateBool(widget.counter.dhekr.istighfar)),
                  ),
                ListTile(
                  title: const Text('لا اله إلا الله 100 مرة'),
                  trailing: Text(translateBool(widget.counter.dhekr.tahlil )),
                  ),
                ListTile(
                  title: const Text('الصلاة على النبي 100 مرة'),
                  trailing: Text(translateBool(widget.counter.dhekr.salah )),
                  ),

                const Divider(),
                coloredArabicText('أعمال أخرى'),
                ListTile(
                  title: const Text('بر الوالدين'),
                  trailing: Text(translateBool(widget.counter.khair.berr )),
                  ),
                ListTile(
                  title: const Text('غض البصر'),
                  trailing: Text(translateBool(widget.counter.khair.ghadd )),
                  ),
                ListTile(
                  title: const Text('صون اللسان'),
                  trailing: Text(translateBool(widget.counter.khair.sawn )),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  String translateBool(bool x) {
    return x ? "قمت بها" : "لم تقم بها";
  }

  String translateSalahCounterTypes(SalahCounterTypes x) {
    switch (x.index) {
      case 0 :
        return "لم تصلّي";
      case 1 :
        return "قضاء";
      case 2 :
        return "فردي";
      case 3 :
        return "جماعة";
      default :
        return "";
    }
  }
}
