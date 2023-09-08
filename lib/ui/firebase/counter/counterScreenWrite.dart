import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:DarAlarkam/backend/firebase/users/get-user.dart';
import 'package:DarAlarkam/services/utils/showSnackBar.dart';
import 'package:DarAlarkam/ui/widgets/text.dart';
import 'package:flutter/material.dart';
import '../../../backend/counter/counter.dart';
import '../../../backend/counter/getCounter.dart'; // Import your Counter class

class CounterScreenWrite extends StatefulWidget {
  final Counter counter;

  CounterScreenWrite({required this.counter});

  @override
  _CounterScreenWriteState createState() => _CounterScreenWriteState();
}

class _CounterScreenWriteState extends State<CounterScreenWrite> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: coloredArabicText('برنامج المحاسبة', c:Colors.white),
          actions: [
            ElevatedButton(
                onPressed: () async {
                  final docUser = FirebaseFirestore.instance.collection('users').doc(getUserId());
                  final docCounter = docUser.collection('counter').doc(getFormattedDate());
                  final json = widget.counter.toJson();

                  await docCounter.set(json).onError((error, stackTrace) {showSnackBar(context, error.toString());});

                },
                child: boldColoredArabicText("حفظ", c:Colors.white)
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                coloredArabicText('التاريخ: ${widget.counter.date}'),
                const Divider(),
                boldColoredArabicText('الصلوات الخمس'),
                ListTile(
                  title: const Text("صلاة الفجر"),
                  subtitle: Text(translateSalahCounterTypes(widget.counter.salah.fajr)),
                  trailing: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.counter.salah.updateFajr();
                      });
                    },
                    child: const Text('غيّر'),
                  ),
                ),
                ListTile(
                  title: const Text("صلاة الظهر"),
                  subtitle: Text(translateSalahCounterTypes(widget.counter.salah.duhr)),
                  trailing: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.counter.salah.updateDuhr();
                      });
                    },
                    child: const Text('غيّر'),
                  ),
                ),
                ListTile(
                  title: const Text("صلاة العصر"),
                  subtitle: Text(translateSalahCounterTypes(widget.counter.salah.asr)),
                  trailing: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.counter.salah.updateAsr();
                      });
                    },
                    child: const Text('غيّر'),
                  ),
                ),
                ListTile(
                  title: const Text("صلاة المغرب"),
                  subtitle: Text(translateSalahCounterTypes(widget.counter.salah.maghrib)),
                  trailing: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.counter.salah.updateMaghrib();
                      });
                    },
                    child: const Text('غيّر'),
                  ),
                ),
                ListTile(
                  title: const Text("صلاة العشاء"),
                  subtitle: Text(translateSalahCounterTypes(widget.counter.salah.ishaa)),
                  trailing: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.counter.salah.updateIshaa();
                      });
                    },
                    child: const Text('غيّر'),
                  ),
                ),

                const Divider(),
                coloredArabicText('النوافل'),
                ListTile(
                  title: const Text('صلاة الضحى'),
                  subtitle: Text(translateBool(widget.counter.nawafel.duha)),
                  trailing: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.counter.nawafel.updateDuha();
                      });
                    },
                    child: const Text('غيّر'),
                  ),
                ),
                ListTile(
                  title: const Text('قيام الليل'),
                  subtitle: Text(translateBool(widget.counter.nawafel.qiyam)),
                  trailing: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.counter.nawafel.updateQiyam();
                      });
                    },
                    child: const Text('غيّر'),
                  ),
                ),
                ListTile(
                  title: const Text('صيام تطوع'),
                  subtitle: Text(translateBool(widget.counter.nawafel.siyam)),
                  trailing: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.counter.nawafel.updateSiyam();
                      });
                    },
                    child: const Text('غيّر'),
                  ),
                ),

                const Divider(),
                coloredArabicText('الأذكار'),
                ListTile(
                  title: const Text('المأثورات'),
                  subtitle: Text(translateBool(widget.counter.dhekr.morningEvening)),
                  trailing: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.counter.dhekr.updateSabah();
                      });
                    },
                    child: const Text('غيّر'),
                  ),
                ),
                ListTile(
                  title: const Text('إستغفار 100 مرة'),
                  subtitle: Text(translateBool(widget.counter.dhekr.istighfar)),
                  trailing: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.counter.dhekr.updateIstighfar();
                      });
                    },
                    child: const Text('غيّر'),
                  ),
                ),
                ListTile(
                  title: const Text('لا اله إلا الله 100 مرة'),
                  subtitle: Text(translateBool(widget.counter.dhekr.tahlil )),
                  trailing: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.counter.dhekr.updateTahlil();
                      });
                    },
                    child: const Text('غيّر'),
                  ),
                ),
                ListTile(
                  title: const Text('الصلاة على النبي 100 مرة'),
                  subtitle: Text(translateBool(widget.counter.dhekr.salah )),
                  trailing: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.counter.dhekr.updateSalah();
                      });
                    },
                    child: const Text('غيّر'),
                  ),
                ),

                const Divider(),
                coloredArabicText('أعمال أخرى'),
                ListTile(
                  title: const Text('بر الوالدين'),
                  subtitle: Text(translateBool(widget.counter.khair.berr )),
                  trailing: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.counter.khair.updateBerr();
                      });
                    },
                    child: const Text('غيّر'),
                  ),
                ),
                ListTile(
                  title: const Text('غض البصر'),
                  subtitle: Text(translateBool(widget.counter.khair.ghadd )),
                  trailing: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.counter.khair.updateGhadd();
                      });
                    },
                    child: const Text('غيّر'),
                  ),
                ),
                ListTile(
                  title: const Text('صون اللسان'),
                  subtitle: Text(translateBool(widget.counter.khair.sawn )),
                  trailing: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.counter.khair.updateSawn();
                      });
                    },
                    child: const Text('غيّر'),
                  ),
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
