import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/olympics_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/uselessness_meter.dart';

class FastestLolScreen extends StatefulWidget {
  const FastestLolScreen({super.key});

  @override
  State<FastestLolScreen> createState() => _FastestLolScreenState();
}

class _FastestLolScreenState extends State<FastestLolScreen> {
  final TextEditingController _controller = TextEditingController();
  final String _targetSequence = 'lol lmao 😂 haha hehe';
  final Stopwatch _stopwatch = Stopwatch();
  bool _isFinished = false;
  double _timeTakenSec = 0.0;

  void _onChanged(String val) {
    if (!_stopwatch.isRunning && !_isFinished && val.isNotEmpty) {
      _stopwatch.reset();
      _stopwatch.start();
    }

    if (val.trim() == _targetSequence && !_isFinished) {
      _stopwatch.stop();
      _timeTakenSec = _stopwatch.elapsedMilliseconds / 1000.0;
      _isFinished = true;
      final provider = context.read<OlympicsProvider>();
      provider.awardMedal('fastest_lol', MedalType.gold);
      setState(() {});
    }
  }

  void _reset() {
    _controller.clear();
    _stopwatch.reset();
    setState(() {
      _isFinished = false;
      _timeTakenSec = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⌨️ Fastest “LOL” Speedrun'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            UselessnessMeter(
              statusText: _isFinished
                  ? 'LOL Typed in ${_timeTakenSec.toStringAsFixed(2)}s! Pure Internet Brainrot.'
                  : 'Type target meme text as fast as humanly possible!',
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
                          color: AppTheme.purpleAccent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.borderColor, width: 2),
                        ),
                        child: const Text('⚡ 0.41 sec', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.yellowAccent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.borderColor, width: 2.5),
                    ),
                    child: Column(
                      children: [
                        const Text('TARGET TEXT TO TYPE:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                        const SizedBox(height: 6),
                        SelectableText(
                          _targetSequence,
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _controller,
                    onChanged: _onChanged,
                    decoration: InputDecoration(
                      hintText: 'Start typing here...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.borderColor, width: 3),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.borderColor, width: 3),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.pinkAccent, width: 3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_isFinished) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.greenAccent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.borderColor, width: 2),
                      ),
                      child: Text(
                        '🥇 GOLD MEDAL! Time: ${_timeTakenSec.toStringAsFixed(2)}s',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  ElevatedButton(
                    onPressed: _reset,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.pinkAccent,
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: AppTheme.borderColor, width: 3),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('RESET SPEEDRUN 🔄',
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
