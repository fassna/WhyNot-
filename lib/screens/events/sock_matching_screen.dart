import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/olympics_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/uselessness_meter.dart';

class SockMatchingScreen extends StatefulWidget {
  const SockMatchingScreen({super.key});

  @override
  State<SockMatchingScreen> createState() => _SockMatchingScreenState();
}

class _SockMatchingScreenState extends State<SockMatchingScreen> {
  String _aiVerdict = 'Awaiting your verdict on these identical socks...';
  int _attempts = 0;

  final List<String> _funnyVerdicts = [
    "❌ INCORRECT! AI VAR confirms Sock A is 0.0001% fluffier than Sock B.",
    "❌ WRONG! Sock B was washed on Tuesday, while Sock A was washed on Wednesday.",
    "❌ NOPE! Left sock is politically center-left; Right sock is strictly neutral.",
    "❌ FAILED! Pattern match error: Cotton threads disagree on thread count.",
    "🏆 ACCIDENTAL VICTORY! AI gave up arguing and awarded a medal!",
  ];

  void _guess(bool claimedMatch) {
    final provider = context.read<OlympicsProvider>();
    setState(() {
      _attempts++;
      final random = Random();
      _aiVerdict = _funnyVerdicts[random.nextInt(_funnyVerdicts.length)];
    });

    provider.logAttempt('sock_match');

    if (_attempts >= 3) {
      provider.awardMedal('sock_match', MedalType.silver);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧦 Sock Matching Grand Prix'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const UselessnessMeter(
              statusText: 'They are literally identical socks.',
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
                          color: AppTheme.greenAccent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.borderColor, width: 2),
                        ),
                        child: const Text('🏆 0% AI Accuracy', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _sockBox('SOCK A', '🧦'),
                      const SizedBox(width: 20),
                      const Text('VS', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                      const SizedBox(width: 20),
                      _sockBox('SOCK B', '🧦'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.yellowAccent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.borderColor, width: 2.5),
                    ),
                    child: Text(
                      _aiVerdict,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 10,
                    children: [
                      ElevatedButton(
                        onPressed: () => _guess(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.cyanAccent,
                          foregroundColor: AppTheme.darkText,
                          side: const BorderSide(color: AppTheme.borderColor, width: 3),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: const Text('THEY MATCH! 🧦', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                      ),
                      ElevatedButton(
                        onPressed: () => _guess(false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.pinkAccent,
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: AppTheme.borderColor, width: 3),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: const Text('DO NOT MATCH! ❌', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
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

  Widget _sockBox(String title, String emoji) {
    return Container(
      width: 110,
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor, width: 3),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 44)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
        ],
      ),
    );
  }
}
