import 'big_calendar_utils.dart';

class BigHijriDate {
  final BigInt year;
  final int month;
  final int day;

  const BigHijriDate({
    required this.year,
    required this.month,
    required this.day,
  });
}

class BigHijriUtils {
  static const List<String> hijriMonths = [
    'Muharram',
    'Safar',
    'Rabiul Awal',
    'Rabiul Akhir',
    'Jumadil Awal',
    'Jumadil Akhir',
    'Rajab',
    'Syaban',
    'Ramadan',
    'Syawal',
    'Zulkaidah',
    'Zulhijah',
  ];

  static BigInt _b(int n) => BigInt.from(n);

  static BigInt _floorDiv(BigInt a, BigInt b) {
    BigInt q = a ~/ b;
    BigInt r = a % b;
    if (r != BigInt.zero && ((r > BigInt.zero) != (b > BigInt.zero))) {
      q -= BigInt.one;
    }
    return q;
  }

  static BigInt _ceilDiv(BigInt a, BigInt b) {
    return -_floorDiv(-a, b);
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

  static BigInt _islamicToJdn(BigHijriDate date) {
    final y = date.year;
    final m = date.month;
    final d = date.day;

    final monthDays = _ceilDiv(BigInt.from(59 * (m - 1)), _b(2));
    return BigInt.from(d) +
        monthDays +
        _b(354) * (y - BigInt.one) +
        _floorDiv(_b(3) + _b(11) * y, _b(30)) +
        _b(1948439) -
        BigInt.one;
  }

  static BigHijriDate gregorianToHijri(BigDate date) {
    if (!BigCalendarUtils.isValidDate(date)) {
      throw ArgumentError('Tanggal Masehi tidak valid');
    }

    final jdn = _gregorianToJdn(date);

    BigInt year =
        _floorDiv(_b(30) * (jdn - _b(1948439)) + _b(10646), _b(10631));

    if (year < BigInt.one) {
      year = BigInt.one;
    }

    int month = 1;
    for (int m = 1; m <= 12; m++) {
      final start = _islamicToJdn(BigHijriDate(year: year, month: m, day: 1));
      final nextStart = m == 12
          ? _islamicToJdn(
              BigHijriDate(year: year + BigInt.one, month: 1, day: 1),
            )
          : _islamicToJdn(
              BigHijriDate(year: year, month: m + 1, day: 1),
            );

      if (jdn >= start && jdn < nextStart) {
        month = m;
        break;
      }
    }

    final startOfMonth =
        _islamicToJdn(BigHijriDate(year: year, month: month, day: 1));
    final day = (jdn - startOfMonth + BigInt.one).toInt();

    return BigHijriDate(year: year, month: month, day: day);
  }
}
