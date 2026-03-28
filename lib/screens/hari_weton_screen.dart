import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'date_input_card.dart';
import 'big_calendar_utils.dart';

class HariWetonScreen extends StatefulWidget {
  const HariWetonScreen({super.key});

  @override
  State<HariWetonScreen> createState() => _HariWetonScreenState();
}

class _HariWetonScreenState extends State<HariWetonScreen> {
  BigDate? _manualDate;
  DateTime? _pickedDate;
  String? _dayName;
  String? _wetonName;
  String? _formattedDate;
  String? _shortDate;
  String? _note;
  String? _dayIndexInfo;
  String? _pasaranIndexInfo;

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
      fieldHintText: 'dd/mm/yyyy',
      locale: const Locale('id', 'ID'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              primary: Colors.blue.shade700,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue.shade700,
                textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    _calculateBigDate(
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
      _showError('Kombinasi tanggal, bulan, dan tahun tidak valid.');
      return;
    }

    _calculateBigDate(bigDate);
  }

  void _calculateBigDate(BigDate bigDate, {DateTime? pickedDateForDisplay}) {
    final dayName = BigCalendarUtils.dayOfWeek(bigDate);
    final wetonName = BigCalendarUtils.weton(bigDate);
    final totalNeptu = BigCalendarUtils.totalNeptu(bigDate);

    final dayIdx = BigCalendarUtils.dayNames.indexOf(dayName);
    final wetonIdx = BigCalendarUtils.wetonNames.indexOf(wetonName);

    setState(() {
      _manualDate = bigDate;
      _pickedDate = pickedDateForDisplay;
      _dayName = dayName;
      _wetonName = wetonName;
      _formattedDate =
          '$dayName, ${bigDate.day.toString().padLeft(2, '0')} ${_monthName(bigDate.month)} ${bigDate.year}';
      _shortDate =
          '${bigDate.day.toString().padLeft(2, '0')} ${_monthShortName(bigDate.month)} ${bigDate.year}';
      _dayIndexInfo = 'Neptu hari: ${BigCalendarUtils.dayNeptu[dayIdx]}';
      _pasaranIndexInfo =
          'Neptu pasaran: ${BigCalendarUtils.wetonNeptu[wetonIdx]} • Total neptu: $totalNeptu';
      _note =
          'Input manual mendukung tahun 1 sampai angka sangat besar. Tombol kalender dipakai hanya untuk tahun normal.';
    });
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

  void _clearResult() {
    setState(() {
      _manualDate = null;
      _pickedDate = null;
      _dayName = null;
      _wetonName = null;
      _formattedDate = null;
      _shortDate = null;
      _note = null;
      _dayIndexInfo = null;
      _pasaranIndexInfo = null;
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

  @override
  Widget build(BuildContext context) {
    final hasResult =
        _manualDate != null &&
        _dayName != null &&
        _wetonName != null &&
        _formattedDate != null &&
        _shortDate != null &&
        _dayIndexInfo != null &&
        _pasaranIndexInfo != null;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Hari & Weton',
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
                Colors.indigo.shade400,
                Colors.blue.shade600,
                Colors.cyan.shade500,
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
                  Colors.indigo.shade400,
                  Colors.blue.shade600,
                  Colors.cyan.shade500,
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade100.withValues(alpha: 0.7),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.white.withValues(alpha: 0.95),
                  size: 34,
                ),
                const SizedBox(height: 14),
                Text(
                  'Cek Hari & Weton',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Masukkan tanggal secara manual untuk tahun berapa pun, atau gunakan kalender untuk tahun normal.',
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    height: 1.5,
                    color: Colors.white.withValues(alpha: 0.92),
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
            title: 'Input Tanggal',
            subtitle:
                'Isi tanggal, bulan, dan tahun secara bebas. Tahun sangat besar hanya didukung lewat input manual.',
            color: Colors.blue,
            initialDay: _manualDate?.day,
            initialMonth: _manualDate?.month,
            initialYear: _manualDate?.year,
            onSubmit: _submitManualDate,
            onPickDate: _pickDate,
            pickButtonText: 'Buka Kalender',
            submitButtonText: 'Cek Hari & Weton',
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
                        icon: Icons.event_note_rounded,
                        title: 'Tanggal Dipilih',
                        value: _formattedDate!,
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
                        icon: Icons.auto_awesome_rounded,
                        title: 'Weton',
                        value: _wetonName!,
                        color: Colors.deepPurple,
                      ),
                      const SizedBox(height: 14),
                      _buildInfoTile(
                        icon: Icons.tag_rounded,
                        title: 'Informasi Neptu',
                        value: '$_dayIndexInfo\n$_pasaranIndexInfo',
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 18),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          'Tanggal $_shortDate jatuh pada hari $_dayName dengan weton $_wetonName.',
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
                        Icons.calendar_view_month_rounded,
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
                        'Masukkan tanggal manual untuk tahun berapa pun atau gunakan kalender untuk tahun normal.',
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
