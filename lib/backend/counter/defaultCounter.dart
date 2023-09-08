import 'counter.dart';

Counter defaultCounter(String uid) {
  DateTime today = DateTime.now();
  String formattedDate = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
  return Counter.fromJson({
    'date': formattedDate,
    'counter': {
      'salah': {
        'fajr': 0,
        'duhr': 0,
        'asr': 0,
        'maghrib': 0,
        'ishaa': 0,
      },
      'nawafel': {
        'duha': false,
        'qiyam': false,
        'siyam': false,
      },
      'dhekr': {
        'morningEvening': false,
        'tahlil': false,
        'salah': false,
        'istighfar': false,
      },
      'khair': {
        'berr': false,
        'ghadd': false,
        'sawn': false,
      },
    },
  });
}