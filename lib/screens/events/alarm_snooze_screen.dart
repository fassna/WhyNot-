import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/olympics_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/uselessness_meter.dart';
import 'package:audioplayers/audioplayers.dart';

class AlarmSnoozeScreen extends StatefulWidget {
  const AlarmSnoozeScreen({super.key});

  @override
  State<AlarmSnoozeScreen> createState() => _AlarmSnoozeScreenState();
}

class _AlarmSnoozeScreenState extends State<AlarmSnoozeScreen> {
  int _snoozeCount = 0;
  bool _isTomorrow = false;
  final AudioPlayer _alarmPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _startAlarm();
  }

  void _startAlarm() async {
    final provider = context.read<OlympicsProvider>();
    if (provider.audioEnabled) {
      await _alarmPlayer.setReleaseMode(ReleaseMode.loop);
      _alarmPlayer.play(AssetSource('audio/alarm.mp3'));
    }
  }

  void _stopAlarm() {
    _alarmPlayer.stop();
  }

  @override
  void dispose() {
    _alarmPlayer.dispose();
    super.dispose();
  }

  void _hitSnooze() {
    final provider = context.read<OlympicsProvider>();
    setState(() {
      _snoozeCount++;
      if (_snoozeCount >= 20) {
        _isTomorrow = true;
        _stopAlarm();
        provider.awardMedal('alarm_snooze', MedalType.gold);
      }
    });
    provider.logAttempt('alarm_snooze');
  }

  void _reset() {
    setState(() {
      _snoozeCount = 0;
      _isTomorrow = false;
    });
    _startAlarm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⏰ Alarm Snooze Championship'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            UselessnessMeter(
              statusText: _isTomorrow
                  ? '🌅 Congratulations. It is tomorrow.'
                  : 'Snoozes hit: $_snoozeCount / 20',
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
                          color: AppTheme.pinkAccent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.borderColor, width: 2),
                        ),
                        child: const Text('🏆 20 Snoozes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _isTomorrow ? AppTheme.yellowAccent : const Color(0xFFFFECEC),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.borderColor, width: 3),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _isTomorrow ? '🌅 IT IS TOMORROW!' : '⏰ BEEP BEEP! 07:00 AM',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            color: _isTomorrow ? AppTheme.darkText : AppTheme.pinkAccent,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _isTomorrow
                              ? 'You hit snooze 20 times. The sun has set and risen again. You are now late for 2027.'
                              : 'WAKE UP! (Or hit snooze 20 times to travel to tomorrow)',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (!_isTomorrow)
                    ElevatedButton.icon(
                      onPressed: _hitSnooze,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.pinkAccent,
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: AppTheme.borderColor, width: 3),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                      icon: const Text('⏰', style: TextStyle(fontSize: 24)),
                      label: Text(
                        'HIT SNOOZE ($_snoozeCount/20)',
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                      ),
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
                      child: const Text('RESET ALARM FOR TOMORROW 🔄',
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
