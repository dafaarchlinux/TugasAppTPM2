import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DateInputValue {
  final int day;
  final int month;
  final BigInt year;

  const DateInputValue({
    required this.day,
    required this.month,
    required this.year,
  });
}

class DateInputCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final MaterialColor color;
  final int? initialDay;
  final int? initialMonth;
  final BigInt? initialYear;
  final ValueChanged<DateInputValue> onSubmit;
  final VoidCallback? onPickDate;
  final bool showPickButton;
  final String pickButtonText;
  final String submitButtonText;

  const DateInputCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onSubmit,
    this.initialDay,
    this.initialMonth,
    this.initialYear,
    this.onPickDate,
    this.showPickButton = true,
    this.pickButtonText = 'Pilih dari Kalender',
    this.submitButtonText = 'Proses Tanggal',
  });

  @override
  State<DateInputCard> createState() => _DateInputCardState();
}

class _DateInputCardState extends State<DateInputCard> {
  late final TextEditingController _dayController;
  late final TextEditingController _monthController;
  late final TextEditingController _yearController;

  @override
  void initState() {
    super.initState();
    _dayController = TextEditingController(
      text: widget.initialDay != null ? '${widget.initialDay}' : '',
    );
    _monthController = TextEditingController(
      text: widget.initialMonth != null ? '${widget.initialMonth}' : '',
    );
    _yearController = TextEditingController(
      text: widget.initialYear != null ? widget.initialYear.toString() : '',
    );
  }

  @override
  void didUpdateWidget(covariant DateInputCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDay != oldWidget.initialDay && widget.initialDay != null) {
      _dayController.text = '${widget.initialDay}';
    }
    if (widget.initialMonth != oldWidget.initialMonth &&
        widget.initialMonth != null) {
      _monthController.text = '${widget.initialMonth}';
    }
    if (widget.initialYear != oldWidget.initialYear &&
        widget.initialYear != null) {
      _yearController.text = widget.initialYear.toString();
    }
  }

  @override
  void dispose() {
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  void _submit() {
    final day = int.tryParse(_dayController.text.trim());
    final month = int.tryParse(_monthController.text.trim());
    final year = BigInt.tryParse(_yearController.text.trim());

    if (day == null || month == null || year == null) {
      _showError('Tanggal, bulan, dan tahun harus berupa angka yang valid.');
      return;
    }

    if (year < BigInt.one) {
      _showError('Tahun minimal adalah 1.');
      return;
    }

    if (month < 1 || month > 12) {
      _showError('Bulan harus berada dalam rentang 1 sampai 12.');
      return;
    }

    if (day < 1 || day > 31) {
      _showError('Tanggal harus berada dalam rentang 1 sampai 31.');
      return;
    }

    widget.onSubmit(
      DateInputValue(day: day, month: month, year: year),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: GoogleFonts.poppins()),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: GoogleFonts.poppins(
        fontSize: 13,
        color: Colors.grey.shade700,
      ),
      hintStyle: GoogleFonts.poppins(
        fontSize: 13,
        color: Colors.grey.shade400,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: widget.color.shade400, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.subtitle,
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _dayController,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.poppins(),
                  decoration: _inputDecoration('Tanggal', '16'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _monthController,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.poppins(),
                  decoration: _inputDecoration('Bulan', '3'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _yearController,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.poppins(),
                  decoration: _inputDecoration('Tahun', '2026 / 1000000000'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  label: Text(
                    widget.submitButtonText,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.color.shade600,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              if (widget.showPickButton && widget.onPickDate != null) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: widget.onPickDate,
                    icon: const Icon(Icons.calendar_month_rounded),
                    label: Text(
                      widget.pickButtonText,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: widget.color.shade700,
                      side: BorderSide(color: widget.color.shade200),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
