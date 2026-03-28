import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'number_properties_utils.dart';

class PropsScreen extends StatefulWidget {
  const PropsScreen({super.key});

  @override
  State<PropsScreen> createState() => _PropsScreenState();
}

class _PropsScreenState extends State<PropsScreen> {
  String input = '';
  String? submittedInput;

  NumberAnalysisResult get analysis =>
      NumberPropertiesUtils.analyze(submittedInput ?? '');

  void onTapKey(String value) {
    setState(() {
      if (value == 'C') {
        input = '';
        submittedInput = null;
        return;
      }

      if (value == '<') {
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
        return;
      }

      if (value == '-') {
        if (input.isEmpty) {
          input = '-';
          return;
        }

        if (input == '-') {
          input = '';
          return;
        }

        if (!input.startsWith('-')) {
          input = '-$input';
        }
        return;
      }

      if (input == '0') {
        input = value;
      } else if (input == '-') {
        input = '-$value';
      } else if (input == '-0') {
        input = '-$value';
      } else {
        input += value;
      }
    });
  }

  void _submitAnalysis() {
    setState(() {
      submittedInput = input;
    });
  }

  Widget _buildPrimaryResultCard({
    required IconData icon,
    required String title,
    required String value,
    required List<Color> gradientColors,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withValues(alpha: 0.20),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.92),
                  ),
                ),
                const SizedBox(height: 6),
                SelectableText(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKey(
    String label, {
    IconData? icon,
    double height = 74,
  }) {
    final isAction = ['C', '-', '<'].contains(label);
    final backgroundColor = isAction
        ? const Color(0xFFECCCF0)
        : const Color(0xFF7E87F1);

    final foregroundColor = isAction
        ? const Color(0xFF33435C)
        : Colors.white;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => onTapKey(label),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: backgroundColor.withValues(alpha: 0.18),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: icon != null
                ? Icon(icon, color: foregroundColor, size: 24)
                : Text(
                    label,
                    style: GoogleFonts.poppins(
                      color: foregroundColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeyRow(List<Widget> children) {
    return Row(
      children: [
        for (int i = 0; i < children.length; i++) ...[
          Expanded(child: children[i]),
          if (i != children.length - 1) const SizedBox(width: 10),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayInput = input.isEmpty ? '0' : input;
    final hasSubmitted = submittedInput != null;
    final isReady = hasSubmitted && analysis.isValid;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Cek Bilangan',
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
                Colors.indigo.shade700,
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
                  Colors.blue.shade400,
                  Colors.blue.shade600,
                  Colors.indigo.shade700,
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
                  Icons.pin_outlined,
                  color: Colors.white.withValues(alpha: 0.95),
                  size: 32,
                ),
                const SizedBox(height: 14),
                Text(
                  'Analisis Bilangan',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Masukkan bilangan bulat positif, negatif, atau nol lalu tekan tombol cek.',
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    height: 1.5,
                    color: Colors.white.withValues(alpha: 0.92),
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                  child: SelectableText(
                    displayInput,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
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
            child: isReady
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hasil Analisis',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildPrimaryResultCard(
                        icon: Icons.flag_rounded,
                        title: 'Jenis Tanda',
                        value: analysis.signLabel,
                        gradientColors: [
                          Colors.blue.shade400,
                          Colors.blue.shade600,
                        ],
                      ),
                      const SizedBox(height: 14),
                      _buildPrimaryResultCard(
                        icon: Icons.swap_vert_circle_rounded,
                        title: 'Ganjil / Genap',
                        value: analysis.parityLabel,
                        gradientColors: [
                          Colors.orange.shade400,
                          Colors.deepOrange.shade500,
                        ],
                      ),
                      const SizedBox(height: 14),
                      _buildPrimaryResultCard(
                        icon: Icons.auto_awesome_rounded,
                        title: 'Prima',
                        value: analysis.primeLabel,
                        gradientColors: [
                          Colors.purple.shade400,
                          Colors.indigo.shade500,
                        ],
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Icon(
                        Icons.pin_outlined,
                        size: 68,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        hasSubmitted
                            ? 'Bilangan belum valid'
                            : 'Belum ada hasil analisis',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        hasSubmitted
                            ? 'Input yang dimasukkan belum dapat dianalisis sebagai bilangan bulat.'
                            : 'Masukkan bilangan lalu tekan tombol Cek Bilangan.',
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
          const SizedBox(height: 20),
          Container(
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
            child: Column(
              children: [
                _buildKeyRow([
                  _buildKey('C'),
                  _buildKey('-'),
                  _buildKey('<', icon: Icons.backspace_outlined),
                ]),
                const SizedBox(height: 10),
                _buildKeyRow([
                  _buildKey('7'),
                  _buildKey('8'),
                  _buildKey('9'),
                ]),
                const SizedBox(height: 10),
                _buildKeyRow([
                  _buildKey('4'),
                  _buildKey('5'),
                  _buildKey('6'),
                ]),
                const SizedBox(height: 10),
                _buildKeyRow([
                  _buildKey('1'),
                  _buildKey('2'),
                  _buildKey('3'),
                ]),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: _buildKey('0'),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _submitAnalysis,
                    icon: const Icon(Icons.search_rounded),
                    label: Text(
                      'Cek Bilangan',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
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
