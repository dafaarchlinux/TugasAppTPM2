import 'package:decimal/decimal.dart';

class HighPrecisionCalculator {
  static String normalizeInput(String input) {
    var text = input.trim().replaceAll(' ', '');

    if (text.isEmpty) return '0';

    if (text.startsWith('.')) {
      text = '0$text';
    }

    if (text.startsWith('-.')) {
      text = text.replaceFirst('-.', '-0.');
    }

    return text;
  }

  static Decimal parseDecimal(String input) {
    final normalized = normalizeInput(input);

    if (!_isValidNumber(normalized)) {
      throw const FormatException('Angka tidak valid');
    }

    return Decimal.parse(normalized);
  }

  static String formatDecimal(Decimal value) {
    final text = value.toString();

    if (!text.contains('.')) return text;

    final trimmed = text
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');

    if (trimmed == '-0') return '0';
    return trimmed;
  }

  static String add(String left, String right) {
    final a = parseDecimal(left);
    final b = parseDecimal(right);
    return formatDecimal(a + b);
  }

  static String subtract(String left, String right) {
    final a = parseDecimal(left);
    final b = parseDecimal(right);
    return formatDecimal(a - b);
  }

  static String multiply(String left, String right) {
    final a = parseDecimal(left);
    final b = parseDecimal(right);
    return formatDecimal(a * b);
  }

  static String divide(String left, String right) {
    final a = parseDecimal(left);
    final b = parseDecimal(right);

    if (b == Decimal.zero) {
      throw const FormatException('Tidak bisa dibagi dengan nol');
    }

    final scale = _divisionScale(left, right);
    final factor = _pow10(scale);
    final scaledDividend = a * Decimal.parse(factor.toString());
    final result = (scaledDividend ~/ b).toString();

    return _formatScaledIntegerString(result, scale);
  }

  static String percent(String input) {
    return divide(input, '100');
  }

  static String toggleSign(String input) {
    final value = parseDecimal(input);
    if (value == Decimal.zero) return '0';
    return formatDecimal(-value);
  }

  static int _divisionScale(String left, String right) {
    final leftDecimals = _decimalDigits(normalizeInput(left));
    final rightDecimals = _decimalDigits(normalizeInput(right));
    final baseScale = leftDecimals > rightDecimals ? leftDecimals + 24 : rightDecimals + 24;
    return baseScale < 24 ? 24 : baseScale;
  }

  static int _decimalDigits(String input) {
    final dotIndex = input.indexOf('.');
    if (dotIndex == -1) return 0;
    return input.length - dotIndex - 1;
  }

  static BigInt _pow10(int exponent) {
    return BigInt.from(10).pow(exponent);
  }

  static String _formatScaledIntegerString(String raw, int scale) {
    var text = raw;
    var negative = false;

    if (text.startsWith('-')) {
      negative = true;
      text = text.substring(1);
    }

    text = text.padLeft(scale + 1, '0');

    final splitIndex = text.length - scale;
    final whole = text.substring(0, splitIndex);
    final fraction = text.substring(splitIndex);

    var combined = '$whole.$fraction'
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');

    if (combined.isEmpty) {
      combined = '0';
    }

    if (negative && combined != '0') {
      combined = '-$combined';
    }

    return combined;
  }

  static bool _isValidNumber(String input) {
    return RegExp(r'^-?\d+(\.\d+)?$').hasMatch(input);
  }
}
