class NumberAnalysisResult {
  final String originalInput;
  final bool isValid;
  final bool isInteger;
  final bool isNegative;
  final bool isZero;
  final bool? isEven;
  final bool? isOdd;
  final bool? isPrime;
  final String signLabel;
  final String parityLabel;
  final String primeLabel;
  final String absoluteValueText;
  final int? digitCount;
  final bool? isPalindrome;

  const NumberAnalysisResult({
    required this.originalInput,
    required this.isValid,
    required this.isInteger,
    required this.isNegative,
    required this.isZero,
    required this.isEven,
    required this.isOdd,
    required this.isPrime,
    required this.signLabel,
    required this.parityLabel,
    required this.primeLabel,
    required this.absoluteValueText,
    required this.digitCount,
    required this.isPalindrome,
  });
}

class NumberPropertiesUtils {
  static NumberAnalysisResult analyze(String rawInput) {
    final input = rawInput.trim();

    if (input.isEmpty || input == '-') {
      return const NumberAnalysisResult(
        originalInput: '',
        isValid: false,
        isInteger: false,
        isNegative: false,
        isZero: false,
        isEven: null,
        isOdd: null,
        isPrime: null,
        signLabel: '-',
        parityLabel: '-',
        primeLabel: '-',
        absoluteValueText: '-',
        digitCount: null,
        isPalindrome: null,
      );
    }

    final integerPattern = RegExp(r'^-?\d+$');
    if (!integerPattern.hasMatch(input)) {
      return NumberAnalysisResult(
        originalInput: input,
        isValid: false,
        isInteger: false,
        isNegative: input.startsWith('-'),
        isZero: false,
        isEven: null,
        isOdd: null,
        isPrime: null,
        signLabel: 'INPUT TIDAK VALID',
        parityLabel: '-',
        primeLabel: '-',
        absoluteValueText: '-',
        digitCount: null,
        isPalindrome: null,
      );
    }

    final value = BigInt.parse(input);
    final isNegative = value.isNegative;
    final isZero = value == BigInt.zero;
    final absoluteValue = value.abs();
    final absoluteDigits = absoluteValue.toString();

    final isEven = value % BigInt.from(2) == BigInt.zero;
    final isOdd = !isEven;
    final isPrime = _isPrime(value);

    return NumberAnalysisResult(
      originalInput: input,
      isValid: true,
      isInteger: true,
      isNegative: isNegative,
      isZero: isZero,
      isEven: isEven,
      isOdd: isOdd,
      isPrime: isPrime,
      signLabel: isZero ? 'NOL' : (isNegative ? 'NEGATIF' : 'POSITIF'),
      parityLabel: isEven ? 'GENAP' : 'GANJIL',
      primeLabel: isPrime ? 'PRIMA' : 'BUKAN PRIMA',
      absoluteValueText: absoluteDigits,
      digitCount: absoluteDigits.length,
      isPalindrome: absoluteDigits == absoluteDigits.split('').reversed.join(),
    );
  }

  static bool _isPrime(BigInt n) {
    if (n < BigInt.from(2)) return false;
    if (n == BigInt.from(2)) return true;
    if (n % BigInt.from(2) == BigInt.zero) return false;

    BigInt i = BigInt.from(3);
    while (i * i <= n) {
      if (n % i == BigInt.zero) return false;
      i += BigInt.from(2);
    }
    return true;
  }
}
