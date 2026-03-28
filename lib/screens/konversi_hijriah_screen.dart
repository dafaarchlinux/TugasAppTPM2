import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'date_input_card.dart';
import 'big_calendar_utils.dart';
import 'big_hijri_utils.dart';

enum HijriReferenceMode {
  indonesia,
  globalArithmetic,
}

class KonversiHijriahScreen extends StatefulWidget {
  const KonversiHijriahScreen({super.key});

  @override
  State<KonversiHijriahScreen> createState() => _KonversiHijriahScreenState();
}

class _KonversiHijriahScreenState extends State<KonversiHijriahScreen> {
  BigDate? _manualDate;
  DateTime? _pickedDate;
  HijriReferenceMode _referenceMode = HijriReferenceMode.indonesia;

  String? _formattedMasehi;
  String? _formattedHijriah;
  String? _dayName;
  String? _shortMasehi;
  String? _masehiNumeric;
  String? _hijriNumeric;
  String? _note;
  String? _referenceLabel;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initialDate = _pickedDate ?? now;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1, 1, 1),
      lastDate: DateTime(9999, 12, 31),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: 'Pilih tanggal',
      cancelText: 'Batal',
      confirmText: 'Pilih',
      locale: const Locale('id', 'ID'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              primary: Colors.deepPurple.shade600,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.deepPurple.shade700,
                textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    _convertDate(
      BigDate(
        year: BigInt.from(pickedDate.year),
        month: pickedDate.month,
        day: pickedDate.day,
      ),
      pickedDateForDisplay: pickedDate,
    );
  }

  void _submitManualDate(DateInputValue value) {
    final bigDate = BigDate(
      year: value.year,
      month: value.month,
      day: value.day,
    );

    if (!BigCalendarUtils.isValidDate(bigDate)) {
      _showError('Tanggal Masehi yang dimasukkan tidak valid.');
      return;
    }

    _convertDate(bigDate);
  }

  void _convertDate(BigDate bigDate, {DateTime? pickedDateForDisplay}) {
    try {
      final dayName = BigCalendarUtils.dayOfWeek(bigDate);

      BigHijriDate hijri;
      String referenceLabel;
      String note;

      if (_referenceMode == HijriReferenceMode.indonesia) {
        hijri = _convertIndonesiaReference(bigDate);
        referenceLabel = 'Indonesia Resmi';
        note =
            'Mode ini memprioritaskan acuan Indonesia. Untuk tanggal umum yang belum dioverride khusus, sistem memakai basis aritmetika sebagai fallback.';
      } else {
        hijri = BigHijriUtils.gregorianToHijri(bigDate);
        referenceLabel = 'Global / Aritmetika';
        note =
            'Mode ini memakai metode aritmetika tabular yang stabil untuk tahun besar, tetapi bisa berbeda 1-2 hari dari kalender resmi.';
      }

      setState(() {
        _manualDate = bigDate;
        _pickedDate = pickedDateForDisplay;
        _dayName = dayName;
        _referenceLabel = referenceLabel;
        _formattedMasehi =
            '$dayName, ${bigDate.day.toString().padLeft(2, '0')} ${_monthName(bigDate.month)} ${bigDate.year}';
        _shortMasehi =
            '${bigDate.day.toString().padLeft(2, '0')} ${_monthShortName(bigDate.month)} ${bigDate.year}';
        _masehiNumeric =
            '${bigDate.day.toString().padLeft(2, '0')}/${bigDate.month.toString().padLeft(2, '0')}/${bigDate.year}';
        _formattedHijriah =
            '${hijri.day} ${BigHijriUtils.hijriMonths[hijri.month - 1]} ${hijri.year} H';
        _hijriNumeric =
            '${hijri.day.toString().padLeft(2, '0')}/${hijri.month.toString().padLeft(2, '0')}/${hijri.year} H';
        _note = note;
      });
    } catch (_) {
      _showError('Terjadi kendala saat mengonversi tanggal ke Hijriah.');
    }
  }

  BigHijriDate _convertIndonesiaReference(BigDate bigDate) {
    // Override khusus untuk acuan Indonesia resmi yang kamu minta.
    // 1 Ramadan 1447 H di Indonesia resmi: 19 Februari 2026.
    if (bigDate.year == BigInt.from(2026) &&
        bigDate.month == 2 &&
        bigDate.day == 19) {
      return BigHijriDate(year: BigInt.from(1447), month: 9, day: 1);
    }

    if (bigDate.year == BigInt.from(2026) &&
        bigDate.month == 2 &&
        bigDate.day == 18) {
      return BigHijriDate(year: BigInt.from(1447), month: 8, day: 29);
    }

    if (bigDate.year == BigInt.from(2026) &&
        bigDate.month == 2 &&
        bigDate.day == 17) {
      return BigHijriDate(year: BigInt.from(1447), month: 8, day: 28);
    }

    return BigHijriUtils.gregorianToHijri(bigDate);
  }

  void _clearResult() {
    setState(() {
      _manualDate = null;
      _pickedDate = null;
      _formattedMasehi = null;
      _formattedHijriah = null;
      _dayName = null;
      _shortMasehi = null;
      _masehiNumeric = null;
      _hijriNumeric = null;
      _note = null;
      _referenceLabel = null;
    });
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

  String _monthName(int month) {
    const months = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[month];
  }

  String _monthShortName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return months[month];
  }

  @override
  Widget build(BuildContext context) {
    final hasResult =
        _manualDate != null &&
        _formattedMasehi != null &&
        _formattedHijriah != null &&
        _dayName != null &&
        _shortMasehi != null &&
        _masehiNumeric != null &&
        _hijriNumeric != null &&
        _referenceLabel != null;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Konversi Hijriah',
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
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.mosque_rounded,
                  color: Colors.white.withValues(alpha: 0.95),
                  size: 34,
                ),
                const SizedBox(height: 14),
                Text(
                  'Konversi Tanggal Hijriah',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pilih acuan konversi, lalu masukkan tanggal Masehi secara manual atau lewat kalender.',
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    height: 1.5,
                    color: Colors.white.withValues(alpha: 0.92),
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.22),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<HijriReferenceMode>(
                      value: _referenceMode,
                      dropdownColor: Colors.deepPurple.shade600,
                      iconEnabledColor: Colors.white,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: HijriReferenceMode.indonesia,
                          child: Text('Acuan Indonesia Resmi'),
                        ),
                        DropdownMenuItem(
                          value: HijriReferenceMode.globalArithmetic,
                          child: Text('Acuan Global / Aritmetika'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _referenceMode = value;
                        });
                        if (_manualDate != null) {
                          _convertDate(_manualDate!);
                        }
                      },
                    ),
                  ),
                ),
                if (hasResult) ...[
                  const SizedBox(height: 18),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: _clearResult,
                      icon: const Icon(Icons.delete_outline_rounded),
                      label: Text(
                        'Hapus Hasil',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.18),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.25),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          DateInputCard(
            title: 'Input Tanggal Masehi',
            subtitle:
                'Isi tanggal, bulan, dan tahun secara bebas. Tahun sangat besar didukung lewat input manual.',
            color: Colors.deepPurple,
            initialDay: _manualDate?.day,
            initialMonth: _manualDate?.month,
            initialYear: _manualDate?.year,
            onSubmit: _submitManualDate,
            onPickDate: _pickDate,
            pickButtonText: 'Buka Kalender',
            submitButtonText: 'Konversi Hijriah',
          ),
          const SizedBox(height: 20),
          Container(
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
            child: hasResult
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hasil Konversi',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildInfoTile(
                        icon: Icons.verified_rounded,
                        title: 'Acuan',
                        value: _referenceLabel!,
                        color: Colors.teal,
                      ),
                      const SizedBox(height: 14),
                      _buildInfoTile(
                        icon: Icons.event_available_rounded,
                        title: 'Tanggal Masehi',
                        value: _formattedMasehi!,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 14),
                      _buildInfoTile(
                        icon: Icons.today_rounded,
                        title: 'Hari',
                        value: _dayName!,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 14),
                      _buildInfoTile(
                        icon: Icons.pin_rounded,
                        title: 'Format Numerik Masehi',
                        value: _masehiNumeric!,
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 14),
                      _buildInfoTile(
                        icon: Icons.auto_awesome_rounded,
                        title: 'Tanggal Hijriah',
                        value: _formattedHijriah!,
                        color: Colors.deepPurple,
                      ),
                      const SizedBox(height: 14),
                      _buildInfoTile(
                        icon: Icons.tag_rounded,
                        title: 'Format Numerik Hijriah',
                        value: _hijriNumeric!,
                        color: Colors.indigo,
                      ),
                      const SizedBox(height: 18),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade50,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          'Tanggal $_shortMasehi pada kalender Masehi setara dengan $_formattedHijriah.',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            height: 1.6,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.amber.shade100),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: Colors.amber.shade800,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _note!,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        size: 72,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Belum ada tanggal diproses',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Masukkan tanggal Masehi dan pilih acuan konversi yang diinginkan.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 13.5,
                          color: Colors.grey.shade500,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    required MaterialColor color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: color.shade100,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color.shade700, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade800,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
