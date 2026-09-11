import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/olympics_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/uselessness_meter.dart';

class WhyDidIOpenThisScreen extends StatefulWidget {
  const WhyDidIOpenThisScreen({super.key});

  @override
  State<WhyDidIOpenThisScreen> createState() => _WhyDidIOpenThisScreenState();
}

class _WhyDidIOpenThisScreenState extends State<WhyDidIOpenThisScreen> {
  int _secondsLeft = 10;
  Timer? _timer;
  bool _forgotten = false;
  String _currentRandomWindow = 'Tab #84: How to order pizza without human contact';

  final List<String> _randomWindows = [
    'Tab #84: How to order pizza without human contact 🍕',
    'Window #12: Calculator (Attempting 2 + 2 again)',
    'Tab #99: Staring at blank Google search box 🔍',
    'Window #4: Fridge Inventory Spreadsheet (0 items)',
    'Tab #300: Shopping cart with 47 unbought items 🛒',
  ];

  void _startTimer() {
    final provider = context.read<OlympicsProvider>();
    _timer?.cancel();
    setState(() {
      _secondsLeft = 10;
      _forgotten = false;
      _currentRandomWindow = (_randomWindows..shuffle()).first;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (mounted) {
        if (_secondsLeft > 1) {
          setState(() => _secondsLeft--);
        } else {
          _timer?.cancel();
          setState(() {
            _secondsLeft = 0;
            _forgotten = true;
          });
          provider.awardMedal('why_opened', MedalType.gold);
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧠 “Why Did I Open This?”'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            UselessnessMeter(
              statusText: _forgotten
                  ? 'Memory state: Completely wiped out.'
                  : 'Time until memory loss: $_secondsLeft sec',
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
                          color: AppTheme.orangeAccent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.borderColor, width: 2),
                        ),
                        child: const Text('🏆 Forgotten in 0.4s', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _forgotten ? AppTheme.pinkAccent : AppTheme.yellowAccent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.borderColor, width: 3),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _forgotten ? '💀 YOU HAVE FORGOTTEN.' : '🧠 RANDOM WINDOW OPENED:',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            color: _forgotten ? Colors.white : AppTheme.darkText,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppTheme.borderColor, width: 2),
                          ),
                          child: Text(
                            _currentRandomWindow,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          _forgotten
                              ? 'After 10 seconds of staring, you have zero memory of why you opened this tab.'
                              : 'Stare at this window for 10 seconds...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: _forgotten ? Colors.white70 : AppTheme.darkText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _startTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.cyanAccent,
                      foregroundColor: AppTheme.darkText,
                      side: const BorderSide(color: AppTheme.borderColor, width: 3),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('OPEN NEW RANDOM TAB 🎲',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
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
