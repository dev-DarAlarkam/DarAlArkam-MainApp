import 'dart:core';

class PrayerTimesDay{
  int day;
  String sunrise;
  String fajr;
  String dhuhr;
  String asr;
  String maghrib;
  String isha;

  PrayerTimesDay(this.day,this.fajr,this.sunrise,this.dhuhr,this.asr,this.maghrib, this.isha);
  factory PrayerTimesDay.fromJson(Map<String, dynamic> json) => PrayerTimesDay(
      json["Day"],
      json["Fajr"],
      json["Sunrise"],
      json["Dhuhr"],
      json["Asr"],
      json["Maghrib"],
      json["Ishaaa"]
  );
  Map<String, dynamic> toJson() => {
    "Sunrise": sunrise,
    "Fajr": fajr,
    "Dhuhr": dhuhr,
    "Asr": asr,
    "Maghrib": maghrib,
    "Isha": isha,
  };
}
