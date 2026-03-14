import 'package:flutter/material.dart';
import 'ui_helpers.dart';

class JumlahTotalScreen extends StatefulWidget {
  const JumlahTotalScreen({super.key});

  @override
  State<JumlahTotalScreen> createState() => _JumlahTotalScreenState();
}

class _JumlahTotalScreenState extends State<JumlahTotalScreen> {
  final List<int> numbers = [];
  String currentInput = '';

  int get total => numbers.fold(0, (sum, item) => sum + item);

  void onKeyTap(String value) {
    setState(() {
      if (value == 'C') {
        currentInput = '';
      } else if (value == '<') {
        if (currentInput.isNotEmpty) {
          currentInput = currentInput.substring(0, currentInput.length - 1);
        }
      } else {
        if (currentInput == '0') {
          currentInput = value;
        } else {
          currentInput += value;
        }
      }
    });
  }

  void addNumber() {
    if (currentInput.isEmpty) return;

    setState(() {
      numbers.add(int.tryParse(currentInput) ?? 0);
      currentInput = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    const labels = [
      '7', '8', '9', '<',
      '4', '5', '6', 'C',
      '1', '2', '3', '0',
    ];

    return Scaffold(
      backgroundColor: AppColors.outerBg,
      appBar: AppBar(
        title: const Text('Jumlah Total Angka'),
        backgroundColor: AppColors.purpleDark,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 430),
            margin: const EdgeInsets.all(18),
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
            decoration: BoxDecoration(
              color: AppColors.appBg,
              borderRadius: BorderRadius.circular(34),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 6),
                const Text(
                  'AKUMULASI TOTAL',
                  style: TextStyle(
                    color: AppColors.titleGrey,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 18),

                // Panel daftar angka
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F1F4),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AppColors.panelBorder),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: numbers.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Belum ada angka ditambahkan',
                                    style: TextStyle(
                                      color: AppColors.titleGrey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              : Scrollbar(
                                  thumbVisibility: true,
                                  radius: const Radius.circular(12),
                                  child: ListView.separated(
                                    itemCount: numbers.length,
                                    separatorBuilder: (_, __) => Divider(
                                      color: Colors.grey.shade300,
                                      height: 1,
                                    ),
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              'ANGKA ${index + 1}',
                                              style: const TextStyle(
                                                color: AppColors.titleGrey,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              numbers[index].toString(),
                                              style: const TextStyle(
                                                color: AppColors.textDark,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        ),
                        const SizedBox(height: 12),
                        Divider(
                          color: Colors.grey.shade400,
                          thickness: 1.2,
                          height: 1,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            const Text(
                              'TOTAL',
                              style: TextStyle(
                                color: Color(0xFF5C63F2),
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              total.toString(),
                              style: const TextStyle(
                                color: Color(0xFF5C63F2),
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Input + tombol tambah
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 58,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF5C63F2),
                            width: 2,
                          ),
                        ),
                        alignment: Alignment.centerRight,
                        child: Text(
                          currentInput.isEmpty ? '0' : currentInput,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 58,
                      width: 132,
                      child: ElevatedButton(
                        onPressed: addNumber,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.purpleDark,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'TAMBAH',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Keypad
                NumberPad(
                  labels: labels,
                  onTap: onKeyTap,
                  childAspectRatio: 1.18,
                  iconMap: const {
                    '<': Icons.backspace_outlined,
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
