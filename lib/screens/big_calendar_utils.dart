class BigDate {
  final BigInt year;
  final int month;
  final int day;

  const BigDate({
    required this.year,
    required this.month,
    required this.day,
  });
}

class BigAgeResult {
  final BigInt years;
  final int months;
  final int days;

  const BigAgeResult({
    required this.years,
    required this.months,
    required this.days,
  });
}

class BigCalendarUtils {
  static const List<String> dayNames = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  static const List<String> wetonNames = [
    'Legi',
    'Pahing',
    'Pon',
    'Wage',
    'Kliwon',
  ];

  static const List<int> wetonNeptu = [5, 9, 7, 4, 8];
  static const List<int> dayNeptu = [4, 3, 7, 8, 6, 9, 5];

  static BigInt _b(int n) => BigInt.from(n);

  static bool isLeapYear(BigInt year) {
    final mod4 = year % _b(4) == BigInt.zero;
    final mod100 = year % _b(100) == BigInt.zero;
    final mod400 = year % _b(400) == BigInt.zero;
    return mod400 || (mod4 && !mod100);
  }

  static int daysInMonth(BigInt year, int month) {
    switch (month) {
      case 1:
      case 3:
      case 5:
      case 7:
      case 8:
      case 10:
      case 12:
        return 31;
      case 4:
      case 6:
      case 9:
      case 11:
        return 30;
      case 2:
        return isLeapYear(year) ? 29 : 28;
      default:
        throw ArgumentError('Bulan tidak valid');
    }
  }

  static bool isValidDate(BigDate date) {
    if (date.month < 1 || date.month > 12) return false;
    if (date.day < 1) return false;
    return date.day <= daysInMonth(date.year, date.month);
  }

  static BigInt _daysBeforeYear(BigInt year) {
    final y = year - BigInt.one;
    return y * _b(365) + y ~/ _b(4) - y ~/ _b(100) + y ~/ _b(400);
  }

  static BigInt _daysBeforeMonth(BigInt year, int month) {
    const offsets = [0, 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
    BigInt result = _b(offsets[month]);
    if (month > 2 && isLeapYear(year)) {
      result += BigInt.one;
    }
    return result;
  }

  static BigInt absoluteDay(BigDate date) {
    if (!isValidDate(date)) {
      throw ArgumentError('Tanggal tidak valid');
    }
    return _daysBeforeYear(date.year) +
        _daysBeforeMonth(date.year, date.month) +
        _b(date.day - 1);
  }

  static String dayOfWeek(BigDate date) {
    final idx = (absoluteDay(date) % _b(7)).toInt();
    return dayNames[idx];
  }

  static String weton(BigDate date) {
    final ref = BigDate(year: _b(1945), month: 8, day: 17);
    final diff = absoluteDay(date) - absoluteDay(ref);
    final idx = ((diff % _b(5)) + _b(5)) % _b(5);
    return wetonNames[idx.toInt()];
  }

  static int totalNeptu(BigDate date) {
    final dayIdx = (absoluteDay(date) % _b(7)).toInt();
    final ref = BigDate(year: _b(1945), month: 8, day: 17);
    final diff = absoluteDay(date) - absoluteDay(ref);
    final wetonIdx = (((diff % _b(5)) + _b(5)) % _b(5)).toInt();
    return dayNeptu[dayIdx] + wetonNeptu[wetonIdx];
  }

  static BigAgeResult ageBetween(BigDate birth, BigDate now) {
    if (!isValidDate(birth) || !isValidDate(now)) {
      throw ArgumentError('Tanggal tidak valid');
    }
    if (absoluteDay(now) < absoluteDay(birth)) {
      throw ArgumentError('Tanggal akhir lebih kecil dari tanggal awal');
    }

    BigInt years = now.year - birth.year;
    int months = now.month - birth.month;
    int days = now.day - birth.day;

    if (days < 0) {
      int prevMonth = now.month - 1;
      BigInt prevYear = now.year;
      if (prevMonth == 0) {
        prevMonth = 12;
        prevYear -= BigInt.one;
      }
      days += daysInMonth(prevYear, prevMonth);
      months--;
    }

    if (months < 0) {
      months += 12;
      years -= BigInt.one;
    }

    return BigAgeResult(years: years, months: months, days: days);
  }
}
