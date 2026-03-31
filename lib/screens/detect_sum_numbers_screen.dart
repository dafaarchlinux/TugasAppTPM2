import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Enum dideklarasikan di luar class
enum OperationType {
  sum('Jumlahkan', '+', Icons.add_circle_outline),
  subtract('Kurangkan', '-', Icons.remove_circle_outline);

  final String label;
  final String symbol;
  final IconData icon;

  const OperationType(this.label, this.symbol, this.icon);
}

class DetectSumNumbersScreen extends StatefulWidget {
  const DetectSumNumbersScreen({super.key});

  @override
  State<DetectSumNumbersScreen> createState() => _DetectSumNumbersScreenState();
}

class _DetectSumNumbersScreenState extends State<DetectSumNumbersScreen> {
  final TextEditingController _textController = TextEditingController();
  OperationType _selectedOperation = OperationType.sum;
  String _result = '';
  List<int> _detectedNumbers = [];

  void _detectAndCalculate() {
    String text = _textController.text.trim();

    if (text.isEmpty) {
      setState(() {
        _result = 'Masukkan teks terlebih dahulu!';
        _detectedNumbers = [];
      });
      return;
    }

    // Regex to find all numbers
    RegExp regex = RegExp(r'-?\d+(?:\.\d+)?');
    Iterable<Match> matches = regex.allMatches(text);

    List<int> numbers = [];
    for (var match in matches) {
      double num = double.parse(match.group(0)!);
      numbers.add(num.toInt());
    }

    setState(() {
      _detectedNumbers = numbers;

      if (numbers.isEmpty) {
        _result = 'Tidak ditemukan angka dalam teks!';
        return;
      }

      // Calculate based on selected operation
      int calculationResult;
      if (_selectedOperation == OperationType.sum) {
        calculationResult = numbers.reduce((a, b) => a + b);
        _result = 'Hasil Penjumlahan: $calculationResult';
      } else {
        // Pengurangan: angka pertama dikurangi angka-angka berikutnya
        if (numbers.isNotEmpty) {
          calculationResult = numbers[0];
          for (int i = 1; i < numbers.length; i++) {
            calculationResult -= numbers[i];
          }
          _result = 'Hasil Pengurangan: $calculationResult';
        } else {
          calculationResult = 0;
          _result = 'Hasil Pengurangan: 0';
        }
      }
    });
  }

  void _clearText() {
    _textController.clear();
    setState(() {
      _result = '';
      _detectedNumbers = [];
    });
  }

  void _showExample() {
    setState(() {
      _textController.text =
          '1 januari 2025 ada 3 anak 5 kucing pada kebun dengan 10 pohon';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Deteksi & Jumlah Angka',
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
                Colors.purple.shade400,
                Colors.purple.shade600,
                Colors.purple.shade800,
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.shade100.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.purple.shade400,
                                Colors.purple.shade600,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.text_fields_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Masukkan Teks',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _textController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText:
                            'Contoh: 1 januari 2025 ada 3 anak 5 kucing pada kebun dengan 10 pohon',
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.grey.shade400,
                          fontSize: 13,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.purple.shade400,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Operation Selection
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          _buildOperationOption(OperationType.sum),
                          const SizedBox(width: 8),
                          _buildOperationOption(OperationType.subtract),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _detectAndCalculate,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple.shade600,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.calculate_rounded,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Hitung',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: _clearText,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            side: BorderSide(
                              color: Colors.grey.shade400,
                            ),
                          ),
                          child: const Icon(Icons.clear),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: _showExample,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            side: BorderSide(
                              color: Colors.grey.shade400,
                            ),
                          ),
                          child: const Icon(Icons.article_rounded),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Detected Numbers Card
            if (_detectedNumbers.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.shade100.withOpacity(0.2),
                      blurRadius: 10,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.numbers_rounded,
                            color: Colors.purple.shade700,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Angka yang Terdeteksi',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _detectedNumbers.map((number) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.purple.shade400,
                                Colors.purple.shade600,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            number.toString(),
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    Divider(color: Colors.grey.shade200),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade50,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Angka yang dideteksi (${_detectedNumbers.length} angka)',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: Colors.purple.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  alignment: WrapAlignment.start,
                                  children: [
                                    ..._detectedNumbers.map(
                                      (number) => Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: Colors.purple.shade200,
                                          ),
                                        ),
                                        child: Text(
                                          number.toString(),
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.purple.shade700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${_selectedOperation.symbol} =',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          constraints: const BoxConstraints(
                            minWidth: 100,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.shade400,
                                Colors.green.shade600,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    Colors.green.shade200.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                'TOTAL',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white70,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _result.split(': ').last,
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOperationOption(OperationType operation) {
    bool isSelected = _selectedOperation == operation;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedOperation = operation;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? operation == OperationType.sum
                    ? Colors.purple.shade100
                    : Colors.purple.shade50
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: isSelected
                ? Border.all(
                    color: operation == OperationType.sum
                        ? Colors.purple.shade400
                        : Colors.purple.shade300,
                    width: 1.5,
                  )
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                operation.icon,
                color: isSelected
                    ? Colors.purple.shade700
                    : Colors.grey.shade600,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                operation.label,
                style: GoogleFonts.poppins(
                  color: isSelected
                      ? Colors.purple.shade700
                      : Colors.grey.shade600,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}