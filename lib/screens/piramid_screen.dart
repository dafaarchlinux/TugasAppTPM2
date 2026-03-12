import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PiramidScreen extends StatefulWidget {
  const PiramidScreen({super.key});

  @override
  State<PiramidScreen> createState() => _PiramidScreenState();
}

class _PiramidScreenState extends State<PiramidScreen> {
  final TextEditingController _sisiAlasController = TextEditingController();
  final TextEditingController _tinggiController = TextEditingController();
  final TextEditingController _tinggiSisiTegakController =
      TextEditingController();

  String _luasPermukaan = '';
  String _volume = '';
  String _errorMessage = '';

  void _hitung() {
    setState(() {
      _errorMessage = '';

      // Validasi input
      if (_sisiAlasController.text.isEmpty ||
          _tinggiController.text.isEmpty ||
          _tinggiSisiTegakController.text.isEmpty) {
        _errorMessage = 'Semua field harus diisi';
        return;
      }

      try {
        double sisiAlas = double.parse(
          _sisiAlasController.text.replaceAll(',', '.'),
        );
        double tinggi = double.parse(
          _tinggiController.text.replaceAll(',', '.'),
        );
        double tinggiSisiTegak = double.parse(
          _tinggiSisiTegakController.text.replaceAll(',', '.'),
        );

        // Validasi angka positif
        if (sisiAlas <= 0 || tinggi <= 0 || tinggiSisiTegak <= 0) {
          _errorMessage = 'Semua nilai harus lebih dari 0';
          return;
        }

        // Hitung luas alas dan keliling alas untuk limas persegi
        double luasAlas = sisiAlas * sisiAlas;
        double kelilingAlas = 4 * sisiAlas;

        // Hitung volume dan luas permukaan
        double volume = (1.0 / 3.0) * luasAlas * tinggi;
        double luasPermukaan =
            luasAlas + (0.5 * kelilingAlas * tinggiSisiTegak);

        // Format hasil
        _luasPermukaan = luasPermukaan.toStringAsFixed(2);
        _volume = volume.toStringAsFixed(2);
      } catch (e) {
        _errorMessage = 'Format angka tidak valid';
      }
    });
  }

  void _clearInput() {
    setState(() {
      _sisiAlasController.clear();
      _tinggiController.clear();
      _tinggiSisiTegakController.clear();
      _luasPermukaan = '';
      _volume = '';
      _errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hitung Limas Persegi'),
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _clearInput),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Card Informasi dengan ilustrasi limas
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.account_balance,
                          size: 60,
                          color: Colors.indigo.shade700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Kalkulator Limas Persegi',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Hitung luas permukaan dan volume\nlimas dengan alas persegi',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Card Informasi Tambahan
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.indigo.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.indigo.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Limas persegi memiliki alas berbentuk persegi dan 4 sisi tegak berbentuk segitiga',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.indigo.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Input Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Masukkan Ukuran',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Isi semua field dengan ukuran yang diinginkan',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Field Sisi Alas
                      _buildInputField(
                        controller: _sisiAlasController,
                        label: 'Panjang Sisi Alas',
                        hint: 'Contoh: 10',
                        icon: Icons.square_foot,
                        description: 'Panjang sisi alas limas (dalam satuan)',
                      ),

                      const SizedBox(height: 20),

                      // Field Tinggi Limas
                      _buildInputField(
                        controller: _tinggiController,
                        label: 'Tinggi Limas',
                        hint: 'Contoh: 15',
                        icon: Icons.height,
                        description: 'Tinggi limas dari alas ke puncak',
                      ),

                      const SizedBox(height: 20),

                      // Field Tinggi Sisi Tegak
                      _buildInputField(
                        controller: _tinggiSisiTegakController,
                        label: 'Tinggi Sisi Tegak',
                        hint: 'Contoh: 12',
                        icon: Icons.straighten,
                        description: 'Tinggi segitiga pada sisi tegak',
                      ),

                      const SizedBox(height: 24),

                      // Tombol Hitung
                      ElevatedButton(
                        onPressed: _hitung,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 24, // tambah padding samping
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          'Hitung',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Error Message
              if (_errorMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage,
                          style: GoogleFonts.poppins(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Hasil Perhitungan
              if (_luasPermukaan.isNotEmpty && _volume.isNotEmpty)
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.indigo.shade600,
                          Colors.indigo.shade400,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Hasil Perhitungan',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Luas Permukaan
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.crop_square,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Luas Permukaan',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '$_luasPermukaan satuan²',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Volume
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.calculate,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Volume',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '$_volume satuan³',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade400,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.indigo.shade400, width: 2),
            ),
            prefixIcon: Icon(icon, color: Colors.indigo.shade400, size: 22),
            filled: true,
            fillColor: Colors.white,
          ),
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: false,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _sisiAlasController.dispose();
    _tinggiController.dispose();
    _tinggiSisiTegakController.dispose();
    super.dispose();
  }
}
