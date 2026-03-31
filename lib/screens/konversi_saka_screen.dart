import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'date_input_card.dart';
import 'big_calendar_utils.dart';
import 'big_saka_utils.dart';

class KonversiSakaScreen extends StatefulWidget {
  const KonversiSakaScreen({super.key});

  @override
  State<KonversiSakaScreen> createState() => _KonversiSakaScreenState();
}

class _KonversiSakaScreenState extends State<KonversiSakaScreen> {
  BigDate? _manualDate;
  DateTime? _pickedDate;
  Map<String, dynamic>? _sakaInfo;

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
              seedColor: Colors.orange,
              primary: Colors.orange.shade700,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.orange.shade700,
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
      final sakaInfo = BigSakaUtils.getFullSakaInfo(bigDate);
      final isLeap = BigSakaUtils.isLeapYear(sakaInfo['year']);
      final daysInMonth = BigSakaUtils.getDaysInMonth(
        sakaInfo['month'], 
        sakaInfo['year'],
      );

      setState(() {
        _manualDate = bigDate;
        _pickedDate = pickedDateForDisplay;
        _sakaInfo = {
          ...sakaInfo,
          'isLeap': isLeap,
          'daysInMonth': daysInMonth,
        };
      });
    } catch (e) {
      _showError('Terjadi kendala saat mengonversi tanggal ke Saka.');
    }
  }

  void _clearResult() {
    setState(() {
      _manualDate = null;
      _pickedDate = null;
      _sakaInfo = null;
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
    final hasResult = _manualDate != null && _sakaInfo != null;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Konversi Kalender Saka',
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
                Colors.orange.shade400,
                Colors.orange.shade600,
                Colors.brown.shade700,
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
                  Colors.orange.shade400,
                  Colors.orange.shade600,
                  Colors.brown.shade700,
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.shade100.withOpacity(0.7),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.park_rounded,
                  color: Colors.white.withOpacity(0.95),
                  size: 34,
                ),
                const SizedBox(height: 14),
                Text(
                  'Konversi Masehi ke Saka',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Kalender Saka digunakan di Bali dan India. Tahun Saka dimulai pada tahun 78 Masehi.',
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    height: 1.5,
                    color: Colors.white.withOpacity(0.92),
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
                        backgroundColor: Colors.white.withOpacity(0.18),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.25),
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
            color: Colors.orange,
            initialDay: _manualDate?.day,
            initialMonth: _manualDate?.month,
            initialYear: _manualDate?.year,
            onSubmit: _submitManualDate,
            onPickDate: _pickDate,
            pickButtonText: 'Buka Kalender',
            submitButtonText: 'Konversi ke Saka',
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
                  color: Colors.black.withOpacity(0.04),
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
                        'Hasil Konversi Kalender Saka',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildInfoTile(
                        icon: Icons.event_available_rounded,
                        title: 'Tanggal Masehi',
                        value: _getFormattedMasehi(),
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 14),
                      _buildInfoTile(
                        icon: Icons.today_rounded,
                        title: 'Hari Masehi',
                        value: BigCalendarUtils.dayOfWeek(_manualDate!),
                        color: Colors.green,
                      ),
                      const SizedBox(height: 14),
                      _buildMainResultTile(
                        icon: Icons.calendar_month_rounded,
                        title: 'Tanggal Saka',
                        value: _sakaInfo!['fullDateIndonesian'],
                        subtitle: 'Tahun ${_sakaInfo!['year']} Saka',
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 14),
                      _buildInfoTile(
                        icon: Icons.wb_sunny,
                        title: 'Hari Saka',
                        value:
                            '${_sakaInfo!['dayName']} (${_sakaInfo!['dayNameIndonesian']})',
                        color: Colors.amber,
                      ),
                      const SizedBox(height: 14),
                      _buildInfoTile(
                        icon: Icons.format_list_numbered,
                        title: 'Bulan Saka',
                        value:
                            '${_sakaInfo!['monthName']} (Bulan ke-${_sakaInfo!['month']})',
                        color: Colors.deepPurple,
                      ),
                      const SizedBox(height: 14),
                      _buildInfoTile(
                        icon: Icons.date_range,
                        title: 'Tahun Saka',
                        value: _sakaInfo!['year'].toString(),
                        color: Colors.teal,
                      ),
                      const SizedBox(height: 14),
                      _buildInfoTile(
                        icon: Icons.calendar_view_month,
                        title: 'Jumlah Hari Bulan Ini',
                        value: '${_sakaInfo!['daysInMonth']} hari',
                        color: Colors.cyan,
                      ),
                      const SizedBox(height: 14),
                      _buildInfoTile(
                        icon: Icons.info_outline,
                        title: 'Tahun Kabisat',
                        value: _sakaInfo!['isLeap'] ? 'Ya' : 'Tidak',
                        color: Colors.pink,
                      ),
                      const SizedBox(height: 18),
                      _buildInfoCard(),
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
                        'Masukkan tanggal Masehi untuk dikonversi ke kalender Saka.',
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

  String _getFormattedMasehi() {
    if (_manualDate == null) return '';
    final dayName = BigCalendarUtils.dayOfWeek(_manualDate!);
    return '$dayName, ${_manualDate!.day.toString().padLeft(2, '0')} ${_getMonthName(_manualDate!.month)} ${_manualDate!.year}';
  }

  String _getMonthName(int month) {
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

  Widget _buildMainResultTile({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required MaterialColor color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.shade100, color.shade50],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: color.shade200,
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color.shade800,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: color.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: Colors.orange.shade700,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'Tentang Kalender Saka',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Kalender Saka adalah kalender yang digunakan di India dan Bali, Indonesia. '
            'Tahun Saka dimulai pada tahun 78 Masehi. Kalender ini digunakan untuk '
            'menentukan hari-hari raya Hindu seperti Nyepi, Galungan, dan Kuningan.',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.orange.shade700,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Nama hari: Redite (Minggu), Soma (Senin), Anggara (Selasa), Buda (Rabu), '
            'Wrespati (Kamis), Sukra (Jumat), Saniscara (Sabtu)',
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.orange.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Nama bulan: Caitra, Waisaka, Jyaistha, Asadha, Srawana, Bhadrawada, '
            'Asuji, Kartika, Margasira, Posya, Magha, Phalguna',
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.orange.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}