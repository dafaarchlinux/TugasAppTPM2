import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_model.dart';
import 'calc_screen.dart';
import 'props_screen.dart';
import 'jumlah_total_screen.dart';
import 'piramid_screen.dart';
import 'stopwatch_screen.dart';
import 'kelompok_screen.dart';
import 'hari_weton_screen.dart';
import 'hitung_umur_screen.dart';
import 'konversi_hijriah_screen.dart';

class MainMenuScreen extends StatelessWidget {
  final User user;

  const MainMenuScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final menuItems = _getMenuItems();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Menu Utama',
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
                Colors.blue.shade400,
                Colors.blue.shade600,
                Colors.blue.shade800,
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue.shade400,
                  Colors.blue.shade600,
                  Colors.blue.shade800,
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade200.withOpacity(0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(
                          user.name[0].toUpperCase(),
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade400,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selamat datang kembali!',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.name,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Active Now',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () => _showLogoutDialog(context),
                    tooltip: 'Logout',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Fitur Aplikasi',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                Text(
                  '${menuItems.length} Menu',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: menuItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final menu = menuItems[index];
                return _buildModernMenuCard(context, menu);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getMenuItems() {
    return [
      {
        'title': 'Data Kelompok',
        'subtitle': 'Lihat informasi anggota kelompok',
        'icon': Icons.people_rounded,
        'color': Colors.orange,
        'gradient': [Colors.orange.shade400, Colors.orange.shade600],
        'route': KelompokScreen(),
        'stats': '4 Anggota',
      },
      {
        'title': 'Kalkulator',
        'subtitle': 'Operasi penjumlahan dan pengurangan',
        'icon': Icons.calculate_rounded,
        'color': Colors.deepPurple,
        'gradient': [Colors.deepPurple.shade400, Colors.deepPurple.shade600],
        'route': const CalcScreen(),
        'stats': '+  -  =',
      },
      {
        'title': 'Cek Bilangan',
        'subtitle': 'Ganjil, genap, dan bilangan prima',
        'icon': Icons.pin_outlined,
        'color': Colors.blue,
        'gradient': [Colors.blue.shade400, Colors.blue.shade600],
        'route': const PropsScreen(),
        'stats': 'Prima',
      },
      {
        'title': 'Jumlah Total Angka',
        'subtitle': 'Penjumlahan angka dengan field dinamis',
        'icon': Icons.functions_rounded,
        'color': Colors.red,
        'gradient': [Colors.red.shade400, Colors.red.shade600],
        'route': const JumlahTotalScreen(),
        'stats': 'Dinamis',
      },
      {
        'title': 'Stopwatch',
        'subtitle': 'Pengukur waktu dengan presisi',
        'icon': Icons.timer_rounded,
        'color': Colors.teal,
        'gradient': [Colors.teal.shade400, Colors.teal.shade600],
        'route': const StopwatchScreen(),
        'stats': 'Real-time',
      },
      {
        'title': 'Hitung Piramid',
        'subtitle': 'Luas permukaan & volume piramid',
        'icon': Icons.account_balance_rounded,
        'color': Colors.indigo,
        'gradient': [Colors.indigo.shade400, Colors.indigo.shade600],
        'route': const PiramidScreen(),
        'stats': '3D Calculator',
      },
      {
        'title': 'Hari & Weton',
        'subtitle': 'Konversi tanggal ke hari dan weton Jawa',
        'icon': Icons.calendar_month_rounded,
        'color': Colors.cyan,
        'gradient': [Colors.cyan.shade400, Colors.blue.shade600],
        'route': const HariWetonScreen(),
        'stats': 'Hari Jawa',
      },
      {
        'title': 'Hitung Umur',
        'subtitle': 'Usia detail dari tanggal lahir sampai hari ini',
        'icon': Icons.cake_rounded,
        'color': Colors.green,
        'gradient': [Colors.green.shade400, Colors.teal.shade600],
        'route': const HitungUmurScreen(),
        'stats': 'Tahun Bulan Hari',
      },
      {
        'title': 'Konversi Hijriah',
        'subtitle': 'Ubah tanggal Masehi menjadi kalender Hijriah',
        'icon': Icons.mosque_rounded,
        'color': Colors.deepPurple,
        'gradient': [Colors.deepPurple.shade400, Colors.indigo.shade600],
        'route': const KonversiHijriahScreen(),
        'stats': 'Hijriah',
      },
    ];
  }

  Widget _buildModernMenuCard(
    BuildContext context,
    Map<String, dynamic> menu,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (menu['color'] as Color).withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => menu['route']),
            );
          },
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: menu['gradient'] as List<Color>,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    menu['icon'] as IconData,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        menu['title'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        menu['subtitle'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: (menu['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          menu['stats'] as String,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: menu['color'] as Color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: (menu['color'] as Color).withOpacity(0.5),
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.red.shade100.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: Colors.red.shade400,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Konfirmasi Logout',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Apakah Anda yakin ingin keluar?',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Text(
                        'Batal',
                        style: GoogleFonts.poppins(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade500,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Logout',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
