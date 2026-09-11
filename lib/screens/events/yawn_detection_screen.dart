import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/olympics_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/uselessness_meter.dart';

class YawnDetectionScreen extends StatefulWidget {
  const YawnDetectionScreen({super.key});

  @override
  State<YawnDetectionScreen> createState() => _YawnDetectionScreenState();
}

class _YawnDetectionScreenState extends State<YawnDetectionScreen> {
  bool _yawnDetected = false;
  bool _isAnalyzing = false;
  String _verdict = 'Camera analyzing facial fatigue...';

  void _triggerYawn() {
    final provider = context.read<OlympicsProvider>();
    setState(() {
      _isAnalyzing = true;
      _verdict = 'AI Scanning mouth opening velocity... 🥱';
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _yawnDetected = true;
          _verdict = '🥇 GOLD MEDAL AWARDED! World Class Yawn detected.';
        });
        provider.awardMedal('yawn_detect', MedalType.gold);
      }
    });
  }

  void _reset() {
    setState(() {
      _yawnDetected = false;
      _isAnalyzing = false;
      _verdict = 'Camera analyzing facial fatigue...';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🥱 Yawn Detection Arena'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            UselessnessMeter(
              statusText: _yawnDetected ? '🥇 GOLD MEDAL! Outstanding exhaustion.' : 'Yawn status: Pending',
            ),
            const SizedBox(height: 16),
            NeoCard(
              backgroundColor: AppTheme.cardBg,
              padding: 20,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        child: Text(
                          'WORLD RECORD:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.yellowAccent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.borderColor, width: 2),
                        ),
                        child: const Text('🥇 100% Contagious', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Webcam Simulator Frame
                  Container(
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E24),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.borderColor, width: 3),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _yawnDetected ? '🥱' : (_isAnalyzing ? '😴' : '🦥'),
                          style: const TextStyle(fontSize: 64),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _yawnDetected ? 'CONTAGIOUS YAWN CONFIRMED!' : 'WEBCAM AI FEED',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _verdict,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.pinkAccent),
                  ),
                  const SizedBox(height: 20),
                  if (!_yawnDetected)
                    ElevatedButton.icon(
                      onPressed: _isAnalyzing ? null : _triggerYawn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.yellowAccent,
                        foregroundColor: AppTheme.darkText,
                        side: const BorderSide(color: AppTheme.borderColor, width: 3),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      ),
                      icon: const Text('🥱', style: TextStyle(fontSize: 20)),
                      label: const Text('SIMULATE YAWN NOW', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                    )
                  else
                    ElevatedButton(
                      onPressed: _reset,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.cyanAccent,
                        foregroundColor: AppTheme.darkText,
                        side: const BorderSide(color: AppTheme.borderColor, width: 3),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('YAWN AGAIN 🔄', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
