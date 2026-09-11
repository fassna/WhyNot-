import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/olympics_provider.dart';
import '../theme/app_theme.dart';
import 'neo_card.dart';

class DiplomaModal extends StatefulWidget {
  const DiplomaModal({super.key});

  @override
  State<DiplomaModal> createState() => _DiplomaModalState();
}

class _DiplomaModalState extends State<DiplomaModal> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 4));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final athlete = context.watch<OlympicsProvider>().athlete;

    return Stack(
      children: [
        Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: NeoCard(
            backgroundColor: const Color(0xFFFFFDF5),
            padding: 24,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Gold border header
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.yellowAccent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.borderColor, width: 3),
                    ),
                    child: const Column(
                      children: [
                        Text('🏅 USELESS OLYMPICS™ 🏅',
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                        Text('“Where Absolutely Nothing Matters”',
                            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'OFFICIAL DIPLOMA OF SHAME',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.pinkAccent,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This certifies that athlete',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.cyanAccent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.borderColor, width: 2),
                    ),
                    child: Text(
                      '${athlete.emoji} ${athlete.name}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'representing ${athlete.delegation}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'has successfully wasted precious minutes of their human lifespan and is hereby crowned:',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.pinkAccent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.borderColor, width: 3),
                    ),
                    child: const Column(
                      children: [
                        Text('🏆 TITLE AWARDED 🏆',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        SizedBox(height: 4),
                        Text(
                          'WORLD\'S MOST USELESS HUMAN',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Breakdown table
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.borderColor, width: 2),
                    ),
                    child: Column(
                      children: [
                        _scoreRow('Reaction Time Rating:', '8.2 / 10 (Sluggish)'),
                        _scoreRow('Pointlessness Score:', '99.9 / 100'),
                        _scoreRow('Productivity Destroyed:', '${(athlete.wastedSeconds / 60).toStringAsFixed(1)} min'),
                        _scoreRow('Pointlessness Score:', '${athlete.overallUselessness} / 100'),
                        const SizedBox(height: 10),
                        const Divider(height: 1, thickness: 1, color: AppTheme.borderColor),
                        const SizedBox(height: 10),
                        _scoreRow('Overall Uselessness:', '🏆 ${athlete.overallUselessness}% MAX', isBold: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.yellowAccent,
                      foregroundColor: AppTheme.darkText,
                      side: const BorderSide(color: AppTheme.borderColor, width: 3),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('ACCEPT MY FATE & CLOSE 💀',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              AppTheme.yellowAccent,
              AppTheme.pinkAccent,
              AppTheme.cyanAccent,
              AppTheme.greenAccent,
              AppTheme.purpleAccent,
            ],
          ),
        ),
      ],
    );
  }

  Widget _scoreRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold ? FontWeight.w900 : FontWeight.bold,
              color: isBold ? AppTheme.pinkAccent : AppTheme.darkText,
            ),
          ),
        ],
      ),
    );
  }
}
