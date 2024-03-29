import 'dart:core';
import 'package:flutter/material.dart';

enum SalahCounterTypes {
  DidntDoIt,
  AfterTime,
  OnTimeAlone,
  OnTimeTogether
}

class SalahCounter {
  SalahCounterTypes fajr = SalahCounterTypes.DidntDoIt;
  SalahCounterTypes duhr = SalahCounterTypes.DidntDoIt;
  SalahCounterTypes asr = SalahCounterTypes.DidntDoIt;
  SalahCounterTypes maghrib = SalahCounterTypes.DidntDoIt;
  SalahCounterTypes ishaa = SalahCounterTypes.DidntDoIt;
  int stat =0;

  SalahCounter();

  void updateFajr() {
    fajr = _getNextEnumValue(fajr);
  }

  void updateDuhr() {
    duhr = _getNextEnumValue(duhr);
  }

  void updateAsr() {
    asr = _getNextEnumValue(asr);
  }

  void updateMaghrib() {
    maghrib = _getNextEnumValue(maghrib);
  }

  void updateIshaa() {
    ishaa = _getNextEnumValue(ishaa);
  }

  void updateStat() {
    stat = fajr.index + duhr.index + asr.index + maghrib.index + ishaa.index;
  }

  SalahCounterTypes _getNextEnumValue(SalahCounterTypes current) {
    final values = SalahCounterTypes.values;
    final nextIndex = (current.index + 1) % values.length;
    return values[nextIndex];
  }

  void resetAllCounters() {
    fajr = SalahCounterTypes.DidntDoIt;
    duhr = SalahCounterTypes.DidntDoIt;
    asr = SalahCounterTypes.DidntDoIt;
    maghrib = SalahCounterTypes.DidntDoIt;
    ishaa = SalahCounterTypes.DidntDoIt;
  }

  Map<String, int> toJson() => {
    "fajr": fajr.index,
    "duhr": duhr.index,
    "asr": asr.index,
    "maghrib": maghrib.index,
    "ishaa": ishaa.index,
  };

  factory SalahCounter.fromJson(Map<String, dynamic> json) {
    final counter = SalahCounter();
    counter.fajr = SalahCounterTypes.values[json["fajr"]];
    counter.duhr = SalahCounterTypes.values[json["duhr"]];
    counter.asr = SalahCounterTypes.values[json["asr"]];
    counter.maghrib = SalahCounterTypes.values[json["maghrib"]];
    counter.ishaa = SalahCounterTypes.values[json["ishaa"]];
    return counter;
  }
}

class NawafelCounter {
  bool duha = false;
  bool qiyam = false;
  bool siyam = false;
  int stat = 0;

  NawafelCounter();

  void updateDuha() {duha = duha? false : true;}
  void updateQiyam() {qiyam = qiyam? false : true;}
  void updateSiyam() {siyam = siyam? false : true;}
  void updateStat() {
    stat = duha ? 1 : 0;
    stat += qiyam ? 1 : 0;
    stat += siyam ? 1 : 0;
  }
  Map<String,dynamic> toJson() => {
    "duha" : duha,
    "qiyam" : qiyam,
    "siyam" : siyam
  };

  factory NawafelCounter.fromJson(Map<String, dynamic> json) {
    final counter = NawafelCounter();
    counter.duha = json["duha"];
    counter.qiyam = json["qiyam"];
    counter.siyam = json["siyam"];
    return counter;
  }
}

class DhekrCounter {
  bool morningEvening = false;
  bool tahlil = false;
  bool salah = false;
  bool istighfar = false;
  int stat = 0;
  DhekrCounter();

  void updateSabah() {morningEvening = morningEvening? false : true;}
  void updateTahlil() {tahlil = tahlil? false : true;}
  void updateSalah() {salah = salah? false : true;}
  void updateIstighfar() {istighfar = istighfar? false : true;}
  void updateStat() {
    stat = morningEvening ? 1 : 0;
    stat += tahlil ? 1 : 0;
    stat += salah ? 1 : 0;
    stat += istighfar ? 1 : 0;
  }
  Map<String,dynamic> toJson() => {
    "morningEvening" : morningEvening,
    "tahlil" : tahlil,
    "salah" : salah,
    "istighfar" : istighfar
  };

  factory DhekrCounter.fromJson(Map<String, dynamic> json) {
    final counter = DhekrCounter();
    counter.morningEvening = json["morningEvening"];
    counter.tahlil = json["tahlil"];
    counter.salah = json["salah"];
    counter.istighfar = json["istighfar"];
    return counter;
  }

}

class KhairCounter {
  bool berr = false;
  bool ghadd = false;
  bool sawn = false;
  int stat = 0;

  KhairCounter();

  void updateBerr() {berr = berr? false : true;}
  void updateGhadd() {ghadd = ghadd? false : true;}
  void updateSawn() {sawn = sawn? false : true;}
  void updateStat() {
    stat = berr ? 1 : 0;
    stat += ghadd ? 1 : 0;
    stat += sawn ? 1 : 0;
  }

  Map<String,dynamic> toJson() => {
    "berr" : berr,
    "ghadd" : ghadd,
    "sawn" : sawn
  };

  factory KhairCounter.fromJson(Map<String, dynamic> json) {
    final counter = KhairCounter();
    counter.berr = json["berr"];
    counter.ghadd = json["ghadd"];
    counter.sawn = json["sawn"];
    return counter;
  }

}

class Counter {
  final String date;
  final SalahCounter salah;
  final NawafelCounter nawafel;
  final DhekrCounter dhekr;
  final KhairCounter khair;
  int stat = 0;

  Counter({
    required this.date,
    required this.salah,
    required this.nawafel,
    required this.dhekr,
    required this.khair,
  });

  int updateStat() {
    salah.updateStat();
    nawafel.updateStat();
    dhekr.updateStat();
    khair.updateStat();

    stat = salah.stat + nawafel.stat + dhekr.stat + khair.stat;
    return stat;
  }

  Map<String, dynamic> toJson() => {
    "date": date,
    "stat" : updateStat(),
    "counter": {
      "salah": salah.toJson(),
      "nawafel": nawafel.toJson(),
      "dhekr": dhekr.toJson(),
      "khair": khair.toJson(),
    },
  };

  factory Counter.fromJson(Map<String, dynamic> json) {
    final counterData = json["counter"];
    return Counter(
      date: json["date"],
      salah: SalahCounter.fromJson(counterData["salah"]),
      nawafel: NawafelCounter.fromJson(counterData["nawafel"]),
      dhekr: DhekrCounter.fromJson(counterData["dhekr"]),
      khair: KhairCounter.fromJson(counterData["khair"]),
    );
  }
}




