import 'big_calendar_utils.dart';

class BigSakaDate {
  final BigInt year;
  final int month;
  final int day;

  const BigSakaDate({
    required this.year,
    required this.month,
    required this.day,
  });
}

class BigSakaUtils {
  static const List<String> sakaMonths = [
    'Caitra',      // Maret-April
    'Waisaka',     // April-Mei
    'Jyaistha',    // Mei-Juni
    'Asadha',      // Juni-Juli
    'Srawana',     // Juli-Agustus
    'Bhadrawada',  // Agustus-September
    'Asuji',       // September-Oktober
    'Kartika',     // Oktober-November
    'Margasira',   // November-Desember
    'Posya',       // Desember-Januari
    'Magha',       // Januari-Februari
    'Phalguna',    // Februari-Maret
  ];

  static const List<String> sakaDays = [
    'Redite',     // Minggu
    'Soma',       // Senin
    'Anggara',    // Selasa
    'Buda',       // Rabu
    'Wrespati',   // Kamis
    'Sukra',      // Jumat
    'Saniscara',  // Sabtu
  ];

  static const Map<String, String> sakaDayTranslations = {
    'Redite': 'Minggu',
    'Soma': 'Senin',
    'Anggara': 'Selasa',
    'Buda': 'Rabu',
    'Wrespati': 'Kamis',
    'Sukra': 'Jumat',
    'Saniscara': 'Sabtu',
  };

  static BigInt _b(int n) => BigInt.from(n);

  static BigInt _floorDiv(BigInt a, BigInt b) {
    BigInt q = a ~/ b;
    BigInt r = a % b;
    if (r != BigInt.zero && ((r > BigInt.zero) != (b > BigInt.zero))) {
      q -= BigInt.one;
    }
    return q;
  }

  static BigInt _gregorianToJdn(BigDate date) {
    final y = date.year;
    final m = BigInt.from(date.month);
    final d = BigInt.from(date.day);

    final a = _floorDiv(_b(14) - m, _b(12));
    final y2 = y + _b(4800) - a;
    final m2 = m + _b(12) * a - _b(3);

    return d +
        _floorDiv(_b(153) * m2 + _b(2), _b(5)) +
        _b(365) * y2 +
        _floorDiv(y2, _b(4)) -
        _floorDiv(y2, _b(100)) +
        _floorDiv(y2, _b(400)) -
        _b(32045);
  }

  static BigInt _sakaToJdn(BigSakaDate date) {
    BigInt gregorianYear = date.year + _b(78);
    int sakaMonth = date.month;
    int sakaDay = date.day;
    
    BigInt totalDays = BigInt.zero;
    
    for (BigInt y = _b(78); y < gregorianYear; y += BigInt.one) {
      bool isLeap = (y % _b(4) == BigInt.zero && 
                     y % _b(100) != BigInt.zero) || 
                    y % _b(400) == BigInt.zero;
      totalDays += isLeap ? _b(366) : _b(365);
    }
    
    for (int m = 1; m < sakaMonth; m++) {
      totalDays += _b(getDaysInMonth(m, date.year));
    }
    
    totalDays += _b(sakaDay);
    
    BigInt baseJdn = _gregorianToJdn(BigDate(year: _b(78), month: 3, day: 1));
    return baseJdn + totalDays - BigInt.one;
  }

  static BigSakaDate gregorianToSaka(BigDate date) {
    if (!BigCalendarUtils.isValidDate(date)) {
      throw ArgumentError('Tanggal Masehi tidak valid');
    }

    final jdn = _gregorianToJdn(date);
    
    BigInt sakaYear = BigInt.zero;
    BigInt estimatedYear = (date.year - _b(78)) + BigInt.one;
    if (date.month < 3) {
      estimatedYear = date.year - _b(78);
    }
    
    if (estimatedYear < BigInt.one) {
      estimatedYear = BigInt.one;
    }
    
    BigInt startJdn = _sakaToJdn(BigSakaDate(year: estimatedYear, month: 1, day: 1));
    BigInt endJdn = _sakaToJdn(BigSakaDate(year: estimatedYear + BigInt.one, month: 1, day: 1));
    
    if (jdn >= startJdn && jdn < endJdn) {
      sakaYear = estimatedYear;
    } else if (jdn < startJdn) {
      sakaYear = estimatedYear - BigInt.one;
    } else {
      sakaYear = estimatedYear + BigInt.one;
    }
    
    int sakaMonth = 1;
    for (int m = 1; m <= 12; m++) {
      final start = _sakaToJdn(BigSakaDate(year: sakaYear, month: m, day: 1));
      final nextStart = m == 12
          ? _sakaToJdn(BigSakaDate(year: sakaYear + BigInt.one, month: 1, day: 1))
          : _sakaToJdn(BigSakaDate(year: sakaYear, month: m + 1, day: 1));
      
      if (jdn >= start && jdn < nextStart) {
        sakaMonth = m;
        break;
      }
    }
    
    final startOfMonth = _sakaToJdn(BigSakaDate(year: sakaYear, month: sakaMonth, day: 1));
    final sakaDay = (jdn - startOfMonth + BigInt.one).toInt();
    
    return BigSakaDate(year: sakaYear, month: sakaMonth, day: sakaDay);
  }
  
  static String getDayName(BigDate date) {
    if (!BigCalendarUtils.isValidDate(date)) {
      throw ArgumentError('Tanggal Masehi tidak valid');
    }
    
    final jdn = _gregorianToJdn(date);
    final dayIndex = ((jdn + BigInt.one) % _b(7)).toInt();
    return sakaDays[dayIndex];
  }
  
  static String getMonthName(int month) {
    if (month < 1 || month > 12) {
      throw ArgumentError('Bulan Saka harus antara 1-12');
    }
    return sakaMonths[month - 1];
  }
  
  static Map<String, dynamic> getFullSakaInfo(BigDate date) {
    final sakaDate = gregorianToSaka(date);
    final dayName = getDayName(date);
    final monthName = getMonthName(sakaDate.month);
    
    return {
      'year': sakaDate.year,
      'month': sakaDate.month,
      'monthName': monthName,
      'day': sakaDate.day,
      'dayName': dayName,
      'dayNameIndonesian': sakaDayTranslations[dayName] ?? dayName,
      'fullDate': '$dayName, ${sakaDate.day} $monthName ${sakaDate.year} Saka',
      'fullDateIndonesian': '${sakaDayTranslations[dayName] ?? dayName}, ${sakaDate.day} $monthName ${sakaDate.year} Saka',
    };
  }
  
  static bool isLeapYear(BigInt sakaYear) {
    BigInt gregorianYear = sakaYear + _b(78);
    return (gregorianYear % _b(4) == BigInt.zero && 
            gregorianYear % _b(100) != BigInt.zero) || 
           gregorianYear % _b(400) == BigInt.zero;
  }
  
  static int getDaysInMonth(int month, BigInt year) {
    if (month < 1 || month > 12) return 0;
    
    const monthDays = [
      31, // Caitra
      30, // Waisaka
      31, // Jyaistha
      30, // Asadha
      31, // Srawana
      31, // Bhadrawada
      30, // Asuji
      30, // Kartika
      30, // Margasira
      30, // Posya
      30, // Magha
      30, // Phalguna
    ];
    
    return monthDays[month - 1];
  }
}