import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'date_input_card.dart';
import 'big_calendar_utils.dart';

class HitungUmurScreen extends StatefulWidget {
  const HitungUmurScreen({super.key});

  @override
  State<HitungUmurScreen> createState() => _HitungUmurScreenState();
}

class _HitungUmurScreenState extends State<HitungUmurScreen> {
  BigDate? _birthDate;
  BigDate? _currentDate;
  BigAgeResult? _ageResult;
  String? _formattedBirthDate;
  String? _formattedCurrentDate;
  String? _dayBornText;
  String? _summaryText;
  String? _calculatedAt;
  String? _zodiacText;
  String? _nextBirthdayText;
  BigInt? _totalDays;
  BigInt? _totalWeeks;
  BigInt? _totalMonthsApprox;
  BigInt? _totalHours;
  BigInt? _totalMinutes;
  BigInt? _totalSeconds;

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 20, now.month, now.day.clamp(1, 28)),
      firstDate: DateTime(1, 1, 1),
      lastDate: DateTime(now.year, now.month, now.day),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: 'Pilih tanggal lahir',
      cancelText: 'Batal',
      confirmText: 'Pilih',
      locale: const Locale('id', 'ID'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              primary: Colors.teal.shade600,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.teal.shade700,
                textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    _calculateAge(
      BigDate(
        year: BigInt.from(pickedDate.year),
        month: pickedDate.month,
        day: pickedDate.day,
      ),
    );
  }

  void _submitManualDate(DateInputValue value) {
    final birthDate = BigDate(
      year: value.year,
      month: value.month,
      day: value.day,
    );

    if (!BigCalendarUtils.isValidDate(birthDate)) {
      _showError('Tanggal lahir tidak valid.');
      return;
    }

    final now = DateTime.now();
    final currentDate = BigDate(
      year: BigInt.from(now.year),
      month: now.month,
      day: now.day,
    );

    if (BigCalendarUtils.absoluteDay(birthDate) >
        BigCalendarUtils.absoluteDay(currentDate)) {
      _showError('Tanggal lahir tidak boleh melebihi hari ini.');
      return;
    }

    _calculateAge(birthDate);
  }

  void _calculateAge(BigDate birthDate) {
    final now = DateTime.now();
    final currentDate = BigDate(
      year: BigInt.from(now.year),
      month: now.month,
      day: now.day,
    );

    final result = BigCalendarUtils.ageBetween(birthDate, currentDate);
    final dayBorn = BigCalendarUtils.dayOfWeek(birthDate);
    final totalDays =
        BigCalendarUtils.absoluteDay(currentDate) - BigCalendarUtils.absoluteDay(birthDate);

    final secondsToday = BigInt.from(
      now.hour * 3600 + now.minute * 60 + now.second,
    );
    final totalHours = totalDays * BigInt.from(24) + BigInt.from(now.hour);
    final totalMinutes = totalDays * BigInt.from(24 * 60) +
        BigInt.from(now.hour * 60 + now.minute);
    final totalSeconds = totalDays * BigInt.from(24 * 3600) + secondsToday;
    final totalWeeks = totalDays ~/ BigInt.from(7);
    final totalMonthsApprox =
        (result.years * BigInt.from(12)) + BigInt.from(result.months);

    setState(() {
      _birthDate = birthDate;
      _currentDate = currentDate;
      _ageResult = result;
      _totalDays = totalDays;
      _totalWeeks = totalWeeks;
      _totalMonthsApprox = totalMonthsApprox;
      _totalHours = totalHours;
      _totalMinutes = totalMinutes;
      _totalSeconds = totalSeconds;
      _formattedBirthDate =
          '$dayBorn, ${birthDate.day.toString().padLeft(2, '0')} ${_monthName(birthDate.month)} ${birthDate.year}';
      _formattedCurrentDate =
          '${currentDate.day.toString().padLeft(2, '0')} ${_monthName(currentDate.month)} ${currentDate.year}';
      _calculatedAt =
          '${currentDate.day.toString().padLeft(2, '0')} ${_monthName(currentDate.month)} ${currentDate.year}, '
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
      _dayBornText = dayBorn;
      _zodiacText = _getZodiac(birthDate.day, birthDate.month);
      _nextBirthdayText = _getNextBirthdayText(birthDate, currentDate);
      _summaryText =
          'Usia saat ini adalah ${result.years} tahun, ${result.months} bulan, dan ${result.days} hari. '
          'Totalnya setara dengan $totalWeeks minggu, $totalDays hari, $totalHours jam, '
          '$totalMinutes menit, dan $totalSeconds detik sejak pukul 00:00 pada tanggal lahir.';
    });
  }

  String _getNextBirthdayText(BigDate birthDate, BigDate currentDate) {
    BigInt targetYear = currentDate.year;
    BigDate nextBirthday = BigDate(
      year: targetYear,
      month: birthDate.month,
      day: birthDate.day,
    );

    if (!BigCalendarUtils.isValidDate(nextBirthday)) {
      nextBirthday = BigDate(
        year: targetYear,
        month: birthDate.month,
        day: BigCalendarUtils.daysInMonth(targetYear, birthDate.month),
      );
    }

    if (BigCalendarUtils.absoluteDay(nextBirthday) <
        BigCalendarUtils.absoluteDay(currentDate)) {
      targetYear = targetYear + BigInt.one;
      nextBirthday = BigDate(
        year: targetYear,
        month: birthDate.month,
        day: birthDate.day,
      );

      if (!BigCalendarUtils.isValidDate(nextBirthday)) {
        nextBirthday = BigDate(
          year: targetYear,
          month: birthDate.month,
          day: BigCalendarUtils.daysInMonth(targetYear, birthDate.month),
        );
      }
    }

    final remainingDays =
        BigCalendarUtils.absoluteDay(nextBirthday) - BigCalendarUtils.absoluteDay(currentDate);

    return '${nextBirthday.day.toString().padLeft(2, '0')} ${_monthName(nextBirthday.month)} ${nextBirthday.year} '
        '(${remainingDays.toString()} hari lagi)';
  }

  String _getZodiac(int day, int month) {
    if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) return 'Aquarius';
    if ((month == 2 && day >= 19) || (month == 3 && day <= 20)) return 'Pisces';
    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) return 'Aries';
    if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) return 'Taurus';
    if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) return 'Gemini';
    if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) return 'Cancer';
    if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) return 'Leo';
    if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) return 'Virgo';
    if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) return 'Libra';
    if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) return 'Scorpio';
    if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) return 'Sagitarius';
    return 'Capricorn';
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

  void _clearResult() {
    setState(() {
      _birthDate = null;
      _currentDate = null;
      _ageResult = null;
      _formattedBirthDate = null;
      _formattedCurrentDate = null;
      _dayBornText = null;
      _summaryText = null;
      _calculatedAt = null;
      _zodiacText = null;
      _nextBirthdayText = null;
      _totalDays = null;
      _totalWeeks = null;
      _totalMonthsApprox = null;
      _totalHours = null;
      _totalMinutes = null;
      _totalSeconds = null;
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
    final hasResult = _birthDate != null &&
        _currentDate != null &&
        _ageResult != null &&
        _formattedBirthDate != null &&
        _formattedCurrentDate != null &&
        _calculatedAt != null &&
        _dayBornText != null &&
        _summaryText != null &&
        _zodiacText != null &&
        _nextBirthdayText != null &&
        _totalDays != null &&
        _totalWeeks != null &&
        _totalMonthsApprox != null &&
        _totalHours != null &&
        _totalMinutes != null &&
        _totalSeconds != null;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Hitung Umur',
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
                Colors.teal.shade400,
                Colors.green.shade500,
                Colors.cyan.shade600,
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
                  Colors.teal.shade400,
                  Colors.green.shade500,
                  Colors.cyan.shade600,
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.shade100.withValues(alpha: 0.7),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.cake_rounded,
                  color: Colors.white.withValues(alpha: 0.95),
                  size: 34,
                ),
                const SizedBox(height: 14),
                Text(
                  'Hitung Umur Detail',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Input manual mendukung tahun sangat besar. Kalender tetap tersedia untuk tahun normal.',
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
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.18),
                        foregroundColor: Colors.white,
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          DateInputCard(
            title: 'Input Tanggal Lahir',
            subtitle:
                'Isi tanggal, bulan, dan tahun lahir secara bebas. Tahun sangat besar didukung lewat input manual.',
            color: Colors.teal,
            initialDay: _birthDate?.day,
            initialMonth: _birthDate?.month,
            initialYear: _birthDate?.year,
            onSubmit: _submitManualDate,
            onPickDate: _pickBirthDate,
            pickButtonText: 'Buka Kalender',
            submitButtonText: 'Hitung Umur',
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: hasResult
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hasil Perhitungan Umur',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildInfoTile(
                        icon: Icons.event_rounded,
                        title: 'Tanggal Lahir',
                        value: _formattedBirthDate!,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 14),
                      _buildInfoTile(
                        icon: Icons.today_rounded,
                        title: 'Tanggal Saat Ini',
                        value: _formattedCurrentDate!,
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 14),
                      _buildInfoTile(
                        icon: Icons.schedule_rounded,
                        title: 'Dihitung Pada',
                        value: _calculatedAt!,
                        color: Colors.teal,
                      ),
                      const SizedBox(height: 14),
                      _buildInfoTile(
                        icon: Icons.auto_awesome_rounded,
                        title: 'Hari Lahir',
                        value: _dayBornText!,
                        color: Colors.deepPurple,
                      ),
                      const SizedBox(height: 14),
                      _buildInfoTile(
                        icon: Icons.stars_rounded,
                        title: 'Zodiak',
                        value: _zodiacText!,
                        color: Colors.pink,
                      ),
                      const SizedBox(height: 14),
                      _buildInfoTile(
                        icon: Icons.celebration_rounded,
                        title: 'Ulang Tahun Berikutnya',
                        value: _nextBirthdayText!,
                        color: Colors.indigo,
                      ),
                      const SizedBox(height: 14),
                      _buildInfoTile(
                        icon: Icons.cake_rounded,
                        title: 'Umur Utama',
                        value:
                            '${_ageResult!.years} tahun, ${_ageResult!.months} bulan, ${_ageResult!.days} hari',
                        color: Colors.green,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Total Bulan',
                              _totalMonthsApprox.toString(),
                              Colors.teal,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'Total Minggu',
                              _totalWeeks.toString(),
                              Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Total Hari',
                              _totalDays.toString(),
                              Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'Total Jam',
                              _totalHours.toString(),
                              Colors.purple,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Total Menit',
                              _totalMinutes.toString(),
                              Colors.red,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'Total Detik',
                              _totalSeconds.toString(),
                              Colors.indigo,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade50,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          _summaryText!,
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            color: Colors.grey.shade700,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Icon(
                        Icons.manage_accounts_rounded,
                        size: 72,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Belum ada tanggal lahir diproses',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
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

  Widget _buildStatCard(String title, String value, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.shade100),
      ),
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
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color.shade800,
            ),
          ),
        ],
      ),
    );
  }
}
