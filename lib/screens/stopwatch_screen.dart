import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  late Stopwatch _stopwatch;
  late Timer _timer;
  bool _isRunning = false;
  List<String> _lapTimes = [];

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _timer = Timer(Duration.zero, () {});
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startStopwatch() {
    setState(() {
      _isRunning = true;
    });
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {});
    });
  }

  void _stopStopwatch() {
    setState(() {
      _isRunning = false;
    });
    _stopwatch.stop();
    _timer.cancel();
  }

  void _resetStopwatch() {
    setState(() {
      _stopwatch.reset();
      _lapTimes.clear();
    });
  }

  void _recordLap() {
    if (_isRunning) {
      setState(() {
        _lapTimes.insert(0, _formatTime());
      });
    }
  }

  String _formatTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String threeDigits(int n) => n.toString().padLeft(3, '0');
    
    final hours = _stopwatch.elapsed.inHours;
    final minutes = _stopwatch.elapsed.inMinutes % 60;
    final seconds = _stopwatch.elapsed.inSeconds % 60;
    // Menghapus variabel milliseconds yang tidak digunakan
    // Langsung menggunakan inMilliseconds untuk format
    
    return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}.${threeDigits(_stopwatch.elapsed.inMilliseconds % 1000)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stopwatch'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.teal.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            // Timer Display
            Container(
              margin: const EdgeInsets.all(30),
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.teal.shade700,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.shade200,
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _formatTime(),
                  style: GoogleFonts.poppins(
                    fontSize: 54,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ).copyWith(
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Control Buttons - Simple icons without background
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Start Button
                if (!_isRunning)
                  IconButton(
                    onPressed: _startStopwatch,
                    icon: const Icon(Icons.play_circle_filled, size: 70),
                    color: Colors.green,
                    tooltip: 'Mulai',
                  ),
                
                // Stop Button
                if (_isRunning)
                  IconButton(
                    onPressed: _stopStopwatch,
                    icon: const Icon(Icons.pause_circle_filled, size: 70),
                    color: Colors.red,
                    tooltip: 'Berhenti',
                  ),
                
                const SizedBox(width: 20),
                
                // Reset Button
                IconButton(
                  onPressed: _resetStopwatch,
                  icon: const Icon(Icons.restart_alt, size: 70),
                  color: Colors.orange,
                  tooltip: 'Reset',
                ),
                
                const SizedBox(width: 20),
                
                // Lap Button
                if (_isRunning)
                  IconButton(
                    onPressed: _recordLap,
                    icon: const Icon(Icons.flag, size: 70),
                    color: Colors.blue,
                    tooltip: 'Catat Lap',
                  ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Lap Times List
            if (_lapTimes.isNotEmpty)
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Catatan Waktu',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.shade700,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _lapTimes.clear();
                              });
                            },
                            child: const Text('Hapus Semua'),
                          ),
                        ],
                      ),
                      const Divider(),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _lapTimes.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: index % 2 == 0 
                                    ? Colors.teal.shade50 
                                    : Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Lap ${_lapTimes.length - index}',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    _lapTimes[index],
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.teal.shade700,
                                    ).copyWith(
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}