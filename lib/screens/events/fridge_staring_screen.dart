import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/olympics_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/uselessness_meter.dart';

class FridgeStaringScreen extends StatefulWidget {
  const FridgeStaringScreen({super.key});

  @override
  State<FridgeStaringScreen> createState() => _FridgeStaringScreenState();
}

class _FridgeStaringScreenState extends State<FridgeStaringScreen> {
  bool _isOpen = false;
  int _opensCount = 0;

  void _toggleFridge() {
    final provider = context.read<OlympicsProvider>();
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) _opensCount++;
    });

    provider.logAttempt('fridge_stare');
    if (_opensCount == 10) {
      provider.awardMedal('fridge_stare', MedalType.bronze);
    } else if (_opensCount == 25) {
      provider.awardMedal('fridge_stare', MedalType.silver);
    } else if (_opensCount == 50) {
      provider.awardMedal('fridge_stare', MedalType.gold);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧊 Fridge Staring Simulator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            UselessnessMeter(
              statusText: 'Fridge opens: $_opensCount. Snacks spawned by magic: 0.',
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
                          color: AppTheme.cyanAccent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.borderColor, width: 2),
                        ),
                        child: const Text('🏆 50 Opens / 0 Snacks', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Refrigerator graphic
                  GestureDetector(
                    onTap: _toggleFridge,
                    child: Container(
                      height: 260,
                      width: 200,
                      decoration: BoxDecoration(
                        color: _isOpen ? const Color(0xFFF4FAFF) : AppTheme.cyanAccent,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppTheme.borderColor, width: 4),
                        boxShadow: const [
                          BoxShadow(color: AppTheme.borderColor, offset: Offset(4, 4)),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_isOpen) ...[
                            const Text('🍋  🥫  🧊', style: TextStyle(fontSize: 32)),
                            const SizedBox(height: 8),
                            const Text('HALF A LEMON & EXPIRED MUSTARD',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11)),
                            const SizedBox(height: 12),
                            const Text('NO NEW SNACKS SPAWNED',
                                style: TextStyle(color: Colors.red, fontWeight: FontWeight.w900, fontSize: 12)),
                          ] else ...[
                            const Icon(Icons.kitchen_rounded, size: 70, color: AppTheme.darkText),
                            const SizedBox(height: 12),
                            const Text('FRIDGE CLOSED 🧊', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                            const SizedBox(height: 6),
                            const Text('OPEN AGAIN HOPING SNACKS APPEAR',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          ]
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _toggleFridge,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.yellowAccent,
                      foregroundColor: AppTheme.darkText,
                      side: const BorderSide(color: AppTheme.borderColor, width: 3),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    ),
                    child: Text(
                      _isOpen ? 'CLOSE FRIDGE 🧊' : 'INSPECT FRIDGE AGAIN 🧊',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                    ),
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
