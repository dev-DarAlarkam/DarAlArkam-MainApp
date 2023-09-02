import 'package:flutter_test/flutter_test.dart';

import '../counter.dart'; // Import your actual Counter class

void main() {
  test('Counter toJson() should return a valid JSON map', () {
    final counter = Counter(
      id: '123',
      date: '0000-00-00',
      salah: SalahCounter(),
      nawafel: NawafelCounter(),
      dhekr: DhekrCounter(),
      khair: KhairCounter(),
    );

    final expectedJson = {
      'id': '123',
      'date': '0000-00-00',
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
          'sabah': false,
          'masaa': false,
          'salah': false,
          'istighfar': false,
        },
        'khair': {
          'berr': false,
          'ghadd': false,
          'sawn': false,
        },
      },
    };

    expect(counter.toJson(), expectedJson);
  });

  test('Counter fromJson() should correctly parse JSON data', () {
    final jsonData = {
      'id': '123',
      'date': '0000-00-00',
      'counter': {
        'salah': {
          'fajr': 1,
          'duhr': 2,
          'asr': 0,
          'maghrib': 3,
          'ishaa': 1,
        },
        'nawafel': {
          'duha': true,
          'qiyam': false,
          'siyam': true,
        },
        'dhekr': {
          'sabah': true,
          'masaa': false,
          'salah': true,
          'istighfar': false,
        },
        'khair': {
          'berr': true,
          'ghadd': false,
          'sawn': true,
        },
      },
    };

    final counter = Counter.fromJson(jsonData);

    expect(counter.id, '123');
    expect(counter.date, '0000-00-00');
    expect(counter.salah.fajr, SalahCounterTypes.AfterTime);
    expect(counter.salah.duhr, SalahCounterTypes.OnTimeAlone);
    expect(counter.salah.asr, SalahCounterTypes.DidntDoIt);
    expect(counter.salah.maghrib, SalahCounterTypes.OnTimeTogether);
    expect(counter.salah.ishaa, SalahCounterTypes.AfterTime);
    expect(counter.nawafel.duha, true);
    expect(counter.nawafel.qiyam, false);
    expect(counter.nawafel.siyam, true);
    expect(counter.dhekr.morningEvening, true);
    expect(counter.dhekr.tahlil, false);
    expect(counter.dhekr.salah, true);
    expect(counter.dhekr.istighfar, false);
    expect(counter.khair.berr, true);
    expect(counter.khair.ghadd, false);
    expect(counter.khair.sawn, true);
  });
}
