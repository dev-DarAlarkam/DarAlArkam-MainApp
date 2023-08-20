import 'package:flutter/material.dart';
import 'package:xml/xml.dart' as xml;
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<String> loadAsset() async {
  return await rootBundle.loadString('lib/assets/files/prayers.xml');
}

Future<Map<String,String>> parseXml() async {
  final xmlString = await loadAsset();
  final document = xml.XmlDocument.parse(xmlString);

  final items = document.findAllElements('item');
  for (var item in items) {
    final date = item.findElements('Date').single.text;
    final fajr = item.findElements('Fajr').single.text;
    final shuruq = item.findElements('Shuruq').single.text;
    final duhr = item.findElements('Duhr').single.text;
    final asr = item.findElements('Asr').single.text;
    final maghrib = item.findElements('Maghrib').single.text;
    final isha = item.findElements('Isha').single.text;

    if (compareDates(date.toString())){
      return {
        'Date': date.toString(),
        'Fajr': fajr.toString(),
        'Shuruq': shuruq.toString(),
        'Duhr': duhr.toString(),
        'Asr': asr.toString(),
        'Maghrib': maghrib.toString(),
        'Isha': isha.toString()
      };
    }
  }
  return {};
}

bool compareDates(String dateString) {
  final currentDate = DateTime.now();
  final dateParts = dateString.split(".");
  if (dateParts.length == 2) {
    final targetMonth = int.tryParse(dateParts[0]);
    final targetDay = int.tryParse(dateParts[1]);

    if (targetMonth != null && targetDay != null) {
      if (currentDate.month == targetMonth && currentDate.day == targetDay) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } else {
    return false;
  }
}
