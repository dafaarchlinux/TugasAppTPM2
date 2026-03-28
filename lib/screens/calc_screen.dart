import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'high_precision_calculator.dart';
import 'ui_helpers.dart';

class CalcScreen extends StatefulWidget {
  const CalcScreen({super.key});

  @override
  State<CalcScreen> createState() => _CalcScreenState();
}

class _CalcScreenState extends State<CalcScreen> {
  String current = '0';
  String expression = '';
  String? firstNumber;
  String? op;
  bool resetOnNextInput = false;
  final List<String> _history = [];

  void _resetAll() {
    current = '0';
    expression = '';
    firstNumber = null;
    op = null;
    resetOnNextInput = false;
  }

  void _setError() {
    expression = 'Error';
    current = '0';
    firstNumber = null;
    op = null;
    resetOnNextInput = true;
  }

  void _addToHistory(String item) {
    _history.insert(0, item);
    if (_history.length > 8) {
      _history.removeLast();
    }
  }

  String _groupDigitsFromRight(String digits, String separator) {
    if (digits.isEmpty) return '0';

    final parts = <String>[];
    for (int end = digits.length; end > 0; end -= 3) {
      final start = (end - 3).clamp(0, digits.length);
      parts.insert(0, digits.substring(start, end));
    }
    return parts.join(separator);
  }

  String _groupDigitsFromLeft(String digits, String separator) {
    if (digits.isEmpty) return '';

    final parts = <String>[];
    for (int start = 0; start < digits.length; start += 3) {
      final end = (start + 3).clamp(0, digits.length);
      parts.add(digits.substring(start, end));
    }
    return parts.join(separator);
  }

  String _formatNumberForDisplay(String raw) {
    if (raw.isEmpty) return raw;
    if (raw == 'Error') return raw;

    final negative = raw.startsWith('-');
    final clean = negative ? raw.substring(1) : raw;
    final split = clean.split('.');

    final integerPart = split.isNotEmpty && split.first.isNotEmpty
        ? split.first
        : '0';
    final fractionPart = split.length > 1 ? split.sublist(1).join('') : '';

    final groupedInteger = _groupDigitsFromRight(integerPart, '.');
    final groupedFraction = _groupDigitsFromLeft(fractionPart, ' ');

    final formatted = fractionPart.isEmpty
        ? groupedInteger
        : '$groupedInteger,$groupedFraction';

    return negative && formatted != '0' ? '-$formatted' : formatted;
  }

  String _injectSoftBreaks(String text) {
    return text
        .replaceAll('.', '.\u200B')
        .replaceAll(',', ',\u200B')
        .replaceAll(' ', ' \u200B');
  }

  String _formatMathText(String text) {
    final regex = RegExp(r'-?\d+(?:\.\d+)?');
    final formatted = text.replaceAllMapped(
      regex,
      (match) => _formatNumberForDisplay(match.group(0)!),
    );
    return _injectSoftBreaks(formatted);
  }

  void _applyPendingOperationIfNeeded(String nextOperator) {
    if (firstNumber == null || op == null || resetOnNextInput) {
      firstNumber = current;
      op = nextOperator;
      expression = '$current $nextOperator';
      resetOnNextInput = true;
      return;
    }

    try {
      String result = current;

      if (op == '+') {
        result = HighPrecisionCalculator.add(firstNumber!, current);
      } else if (op == '-') {
        result = HighPrecisionCalculator.subtract(firstNumber!, current);
      } else if (op == '×') {
        result = HighPrecisionCalculator.multiply(firstNumber!, current);
      } else if (op == '÷') {
        result = HighPrecisionCalculator.divide(firstNumber!, current);
      }

      final fullExpression = '${firstNumber!} $op $current = $result';
      _addToHistory(fullExpression);

      current = result;
      firstNumber = result;
      op = nextOperator;
      expression = '$result $nextOperator';
      resetOnNextInput = true;
    } catch (_) {
      _setError();
    }
  }

  void onButtonTap(String value) {
    setState(() {
      if (value == 'C') {
        _resetAll();
        return;
      }

      if (value == '<') {
        if (resetOnNextInput) {
          current = '0';
          resetOnNextInput = false;
          return;
        }

        if (current.length > 1) {
          current = current.substring(0, current.length - 1);
          if (current == '-' || current.isEmpty) {
            current = '0';
          }
        } else {
          current = '0';
        }
        return;
      }

      if (value == '±') {
        try {
          current = HighPrecisionCalculator.toggleSign(current);
          if (firstNumber != null && op != null) {
            expression = '$firstNumber $op';
          }
        } catch (_) {
          _setError();
        }
        return;
      }

      if (value == '%') {
        try {
          final before = current;
          current = HighPrecisionCalculator.percent(current);
          expression = '$before %';
          _addToHistory('$before % = $current');
          resetOnNextInput = true;
        } catch (_) {
          _setError();
        }
        return;
      }

      if (value == '+' || value == '-' || value == '×' || value == '÷') {
        _applyPendingOperationIfNeeded(value);
        return;
      }

      if (value == '=') {
        if (firstNumber != null && op != null) {
          try {
            final second = current;
            String result = '0';

            if (op == '+') {
              result = HighPrecisionCalculator.add(firstNumber!, second);
            } else if (op == '-') {
              result = HighPrecisionCalculator.subtract(firstNumber!, second);
            } else if (op == '×') {
              result = HighPrecisionCalculator.multiply(firstNumber!, second);
            } else if (op == '÷') {
              result = HighPrecisionCalculator.divide(firstNumber!, second);
            }

            final fullExpression = '${firstNumber!} $op $second = $result';
            expression = '${firstNumber!} $op $second =';
            current = result;
            _addToHistory(fullExpression);
            firstNumber = null;
            op = null;
            resetOnNextInput = true;
          } catch (_) {
            _setError();
          }
        }
        return;
      }

      if (value == '.') {
        if (resetOnNextInput) {
          current = '0.';
          resetOnNextInput = false;
          return;
        }

        if (!current.contains('.')) {
          current += '.';
        }
        return;
      }

      if (resetOnNextInput || current == '0') {
        current = value;
        resetOnNextInput = false;
      } else {
        current += value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const labels = [
      'C', '±', '%', '÷',
      '7', '8', '9', '×',
      '4', '5', '6', '-',
      '1', '2', '3', '+',
      '0', '.', '=', '<',
    ];

    final displayCurrent = _injectSoftBreaks(_formatNumberForDisplay(current));
    final displayExpression = expression.isEmpty
        ? ' '
        : _formatMathText(expression);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Kalkulator',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.deepPurple.shade400,
                Colors.purple.shade500,
                Colors.indigo.shade600,
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 40),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.deepPurple.shade400,
                            Colors.purple.shade500,
                            Colors.indigo.shade600,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.shade100.withValues(alpha: 0.7),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(
                          minHeight: 170,
                          maxHeight: 320,
                        ),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.18),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: double.infinity,
                              constraints: const BoxConstraints(
                                minHeight: 28,
                                maxHeight: 78,
                              ),
                              child: SingleChildScrollView(
                                reverse: true,
                                child: SelectableText(
                                  displayExpression,
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white.withValues(alpha: 0.82),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    height: 1.45,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.bottomRight,
                                child: Scrollbar(
                                  thumbVisibility: true,
                                  child: SingleChildScrollView(
                                    reverse: true,
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: SelectableText(
                                        displayCurrent,
                                        textAlign: TextAlign.right,
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w700,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.history_rounded,
                                color: Colors.deepPurple.shade400,
                                size: 19,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Riwayat',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              const Spacer(),
                              if (_history.isNotEmpty)
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _history.clear();
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.deepPurple.shade500,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                  ),
                                  child: Text(
                                    'Hapus',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: _history.isEmpty ? null : 96,
                            child: _history.isEmpty
                                ? Text(
                                    'Belum ada riwayat perhitungan.',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.grey.shade500,
                                    ),
                                  )
                                : ListView.separated(
                                    itemCount: _history.length,
                                    padding: EdgeInsets.zero,
                                    physics: const BouncingScrollPhysics(),
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 8),
                                    itemBuilder: (context, index) {
                                      return SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          _formatMathText(_history[index]),
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            color: Colors.grey.shade700,
                                            height: 1.35,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: NumberPad(
                        labels: labels,
                        onTap: onButtonTap,
                        childAspectRatio: 1.08,
                        iconMap: const {
                          '<': Icons.backspace_outlined,
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
