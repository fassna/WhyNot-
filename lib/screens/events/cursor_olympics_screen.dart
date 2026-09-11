import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/olympics_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/uselessness_meter.dart';

class CursorOlympicsScreen extends StatefulWidget {
  const CursorOlympicsScreen({super.key});

  @override
  State<CursorOlympicsScreen> createState() => _CursorOlympicsScreenState();
}

class _CursorOlympicsScreenState extends State<CursorOlympicsScreen> {
  Offset _petPos = const Offset(40, 40);
  bool _reachedEnd = false;
  String _message = 'Drag cute dog cursor 🐶 from START to END!';

  void _onPanUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    if (_reachedEnd) return;
    setState(() {
      double newX = (_petPos.dx + details.delta.dx).clamp(20, constraints.maxWidth - 20);
      double newY = (_petPos.dy + details.delta.dy).clamp(20, constraints.maxHeight - 20);
      _petPos = Offset(newX, newY);

      // Check if reached finish box at bottom right
      if (newX > constraints.maxWidth - 70 && newY > constraints.maxHeight - 70) {
        _reachedEnd = true;
        _message = '🎉 CONGRATULATIONS! REWARD DISCOVERED: Absolutely Nothing.';
        final provider = context.read<OlympicsProvider>();
        provider.awardMedal('cursor_maze', MedalType.gold);
      }
    });
  }

  void _reset() {
    setState(() {
      _petPos = const Offset(40, 40);
      _reachedEnd = false;
      _message = 'Drag cute dog cursor 🐶 from START to END!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🖱️ Cursor Olympics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            UselessnessMeter(
              statusText: _reachedEnd
                  ? 'Maze completed. Life value added: 0%.'
                  : 'Navigating unnecessarily complex dog maze...',
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
                        child: const Text('🏆 100% Wasted', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(_message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.pinkAccent)),
                  const SizedBox(height: 16),
                  // Maze Canvas Container
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return GestureDetector(
                        onPanUpdate: (d) => _onPanUpdate(d, constraints),
                        child: Container(
                          height: 260,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFBEA),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppTheme.borderColor, width: 3),
                          ),
                          child: Stack(
                            children: [
                              // Start Box
                              Positioned(
                                left: 10,
                                top: 10,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppTheme.greenAccent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text('START 🚀', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                                ),
                              ),
                              // Finish Box
                              Positioned(
                                right: 10,
                                bottom: 10,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppTheme.pinkAccent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text('NO REWARD 🎁', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                                ),
                              ),
                              // Pet Cursor
                              Positioned(
                                left: _petPos.dx - 20,
                                top: _petPos.dy - 20,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                                  ),
                                  child: const Text('🐶', style: TextStyle(fontSize: 28)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _reset,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.yellowAccent,
                      foregroundColor: AppTheme.darkText,
                      side: const BorderSide(color: AppTheme.borderColor, width: 3),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('TRY MAZE AGAIN 🔄', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
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
