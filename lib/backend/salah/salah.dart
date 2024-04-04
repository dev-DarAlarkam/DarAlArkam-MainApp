import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart' as xml;
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

Future<void> createDstStatusFile() async {

  Map<String, bool> content = {"dst" : false};
  String jsonString = json.encode(content);

  try {

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/dst.json');
    await file.writeAsString(jsonString);

  } catch (e) {

    print('Failed to save file: $e');

  }
}

Future<bool> readDSTStatus() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/dst.json');
  String content = await file.readAsString();
  try {
    // Read the JSON asset file
    Map<String, dynamic> map = json.decode(content);
    bool isDst = map["dst"];
    return isDst;

  } catch (e) {
    await createDstStatusFile();
    return await readDSTStatus();

  }
}


Future<void> updateDstStatus(bool isDst) async {
  Map<String, bool> content = {"dst" : isDst ? false : true};
  String jsonString = json.encode(content);

  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/dst.json');
    await file.writeAsString(jsonString);
    print('File saved successfully');
    print(directory.path.toString());

  } catch (e) {
    print('Failed to save file: $e');
  }
}



Future<void> createSalahNotificationFile() async {

  Map<String, bool> defaultContent = {
    "Fajr" : false,
    "Shuruq" : false,
    "Duhr" : false,
    "Asr" : false,
    "Maghrib" : false,
    "Isha" : false
  };
  String jsonString = json.encode(defaultContent);

  try {

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/salahNotifications.json');
    await file.writeAsString(jsonString);

  } catch (e) {

    print('Failed to save file: $e');

  }
}

Future<Map<String, dynamic>> readSalahNotificationStatus() async {

  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/salahNotifications.json');
  String content = await file.readAsString();

  try {
    // Read the JSON asset file
    Map<String, dynamic> map = json.decode(content);
    return map;

  } catch (e) {
    await createSalahNotificationFile();
    return await readSalahNotificationStatus();

  }
}


Future<void> updateSalahNotificationStatus(Map<String, dynamic> content) async {
  String jsonString = json.encode(content);

  try {

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/salahNotifications.json');
    await file.writeAsString(jsonString);
    print('File saved successfully');

  } catch (e) {
    print('Failed to save file: $e');
  }
}






Future<String> loadAsset() async {
  return await rootBundle.loadString('lib/assets/files/prayers.xml');
}

Future<Map<String,String>> parseXml(DateTime chosenDate) async {
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

    if (compareDates(chosenDate, date.toString())){
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

bool compareDates(DateTime chosenDate, String dateString) {
  final currentDate = chosenDate;
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

String adjustTimeForDST(String timeStr, bool isDST) {
  final timeParts = timeStr.split(":");
  if (timeParts.length == 2) {
    final hour = int.tryParse(timeParts[0]);
    final minute = int.tryParse(timeParts[1]);

    if (hour != null && minute != null) {
      if (isDST) {
        final adjustedHour = (hour + 1) % 24;
        return "${adjustedHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
      }

      // If not DST or DST adjustment not needed, return the original time
      return "$hour:${minute.toString().padLeft(2, '0')}";
    }
  }

  // Return the input time if parsing failed
  return timeStr;
}