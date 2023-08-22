import 'package:hijri/hijri_calendar.dart';

String getTodayDateH(){
  var _today = HijriCalendar.now();

  String result = _today.hDay.toString() + " ";
  result += getMonthNameInArabic(_today.hMonth) + " ";
  result += _today.hYear.toString() + " هـ";
  return result;
}

String getMonthNameInArabic(int month) {
  switch(month) {
    case 1 : {
      return "مُحرّم" ;
    }

    case 2: {
      return "صفر";
    }

    case 3: {
      return "ربيع الأول";
    }

    case 4: {
      return "ربيع الثاني";
    }

    case 5: {
      return "جُمادى الأولى";
    }

    case 6: {
      return "جُمادى الآخرة";
    }

    case 7: {
      return "رجب";
    }

    case 8: {
      return "شعبان";
    }

    case 9: {
      return "رمضان";
    }

    case 10: {
      return "شوال";
    }

    case 11: {
      return "ذو القعدة";
    }

    case 12: {
      return "ذو الحجة";
    }

    default: {
      return "";
    }
  }
}

