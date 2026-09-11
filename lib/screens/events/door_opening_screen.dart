import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/olympics_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/uselessness_meter.dart';

class DoorOpeningScreen extends StatefulWidget {
  const DoorOpeningScreen({super.key});

  @override
  State<DoorOpeningScreen> createState() => _DoorOpeningScreenState();
}

class _DoorOpeningScreenState extends State<DoorOpeningScreen> {
  bool _isOpen = false;
  int _doorCount = 0;

  void _toggleDoor() {
    final provider = context.read<OlympicsProvider>();
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) _doorCount++;
    });

    provider.logAttempt('door');
    if (_doorCount == 10) {
      provider.awardMedal('door', MedalType.bronze);
    } else if (_doorCount == 25) {
      provider.awardMedal('door', MedalType.silver);
    } else if (_doorCount == 50) {
      provider.awardMedal('door', MedalType.gold);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🚪 Door Opening Championship'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const UselessnessMeter(
              statusText: 'Reason for opening this door: Absolutely None.',
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
                        child: const Text('🏆 124 Opens', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Animated door container
                  GestureDetector(
                    onTap: _toggleDoor,
                    child: Container(
                      height: 250,
                      width: 180,
                      decoration: BoxDecoration(
                        color: _isOpen ? const Color(0xFFE2E2E2) : AppTheme.orangeAccent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.borderColor, width: 4),
                        boxShadow: const [
                          BoxShadow(color: AppTheme.borderColor, offset: Offset(4, 4)),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isOpen ? Icons.sensor_door_outlined : Icons.meeting_room_rounded,
                            size: 80,
                            color: _isOpen ? Colors.black45 : Colors.white,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _isOpen ? 'DOOR OPEN 🚪' : 'DOOR CLOSED 🚪',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              color: _isOpen ? AppTheme.darkText : Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _isOpen ? 'TAP TO CLOSE' : 'TAP TO OPEN',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: _isOpen ? Colors.black54 : Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.yellowAccent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.borderColor, width: 2),
                    ),
                    child: const Text(
                      'Why are you doing this? There is no reason.',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    alignment: WrapAlignment.spaceAround,
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _stat('Times Opened', '$_doorCount'),
                      _stat('Draft Created', '${_doorCount * 2} %'),
                      _stat('Hinge Wear', '${_doorCount * 0.5}%'),
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

  Widget _stat(String title, String val) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(val, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
      ],
    );
  }
}
