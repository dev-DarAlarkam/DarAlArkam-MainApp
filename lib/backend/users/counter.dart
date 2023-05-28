import 'dart:core';

enum SalahCounterTypes{
  DidntDoIt, AfterTime, OnTimeAlone, OnTimeTogether
}

class SalahCounter{

  SalahCounterTypes fajr= SalahCounterTypes.DidntDoIt;
  SalahCounterTypes duhr= SalahCounterTypes.DidntDoIt;
  SalahCounterTypes asr= SalahCounterTypes.DidntDoIt;
  SalahCounterTypes maghrib= SalahCounterTypes.DidntDoIt;
  SalahCounterTypes ishaa= SalahCounterTypes.DidntDoIt;

  void updateFajr(SalahCounterTypes update) {fajr = update;}
  void updateDuhr(SalahCounterTypes update) {duhr = update;}
  void updateAsr(SalahCounterTypes update) {asr = update;}
  void updateMaghrib(SalahCounterTypes update) {maghrib = update;}
  void updateIshaa(SalahCounterTypes update) {ishaa = update;}

  Map<String, int> toJson() => {
      "Fajr" : fajr.index,
      "Duhr" : duhr.index,
      "Asr" : asr.index,
      "Maghrib": maghrib.index,
      "Ishaa" : ishaa.index
  };
}

class NawafelCounter {
  bool duha = false;
  bool qiyam = false;
  bool siyam = false;

  void updateDuha(bool update) {duha = update;}
  void updateQiyam(bool update) {qiyam = update;}
  void updateSiyam(bool update) {siyam = update;}

  Map<String,int> toJson() => {
    "duha" : duha ? 1 : 0,
    "qiyam" : qiyam ? 1 : 0,
    "siyam" : siyam ? 1 : 0
  };
}

class DhekrCounter {
  bool sabah = false;
  bool masaa = false;
  bool salah = false;
  bool istighfar = false;

  void updateSabah(bool update) {sabah = update;}
  void updateMasaa(bool update) {masaa = update;}
  void updateSalah(bool update) {salah = update;}
  void updateIstighfar(bool update) {istighfar = update;}

  Map<String,int> toJson() => {
    "sabah" : sabah ? 1 : 0,
    "masaa" : masaa ? 1 : 0,
    "salah" : salah ? 1 : 0,
    "istighfar" : istighfar ? 1 : 0
  };
}

class KhairCounter {
  bool berr = false;
  bool ghadd = false;
  bool sawn = false;

  void updateBerr(bool update) {berr = update;}
  void updateGhadd(bool update) {ghadd = update;}
  void updateSawn(bool update) {sawn = update;}

  Map<String,int> toJson() => {
    "berr" : berr ? 1 : 0,
    "ghadd" : ghadd ? 1 : 0,
    "sawn" : sawn ? 1 : 0
  };
}

class Counter{
  final String studentId;
  DateTime _now = DateTime.now();
  DateTime _nowDateOnly = DateTime(0000, 00, 00);
  SalahCounter _salah = SalahCounter();
  NawafelCounter _nawafel = NawafelCounter();
  DhekrCounter _dhekr = DhekrCounter();
  KhairCounter _khair = KhairCounter();

  Map<DateTime, Map<String, Map<String, int>>> counter ={};

  Counter(this.studentId) {
    _now = DateTime.now();
    _nowDateOnly = DateTime(_now.year, _now.month, _now.day);
  }

  void resetCounter(){
    _now = DateTime.now();
    // Extracting only the date part
    _nowDateOnly = DateTime(_now.year, _now.month, _now.day);
    _salah = SalahCounter();
    _nawafel = NawafelCounter();
    _dhekr = DhekrCounter();
    _khair = KhairCounter();
  }

  void updateCounter(KhairCounter k, DhekrCounter d, NawafelCounter n, SalahCounter s) {
    _salah = s;
    _nawafel = n;
    _dhekr = d;
    _khair = k;

    DateTime temp = DateTime.now();
    if (temp.isAfter(_now)) {
      resetCounter();
    }
    counter[_nowDateOnly]= {
      "salah": _salah.toJson(),
      "nawafel": _nawafel.toJson(),
      "dhekr": _dhekr.toJson(),
      "khair": _khair.toJson()
    };
  }

  Map<DateTime, Map<String, Map<String, int>>> toJson() => counter;

}

