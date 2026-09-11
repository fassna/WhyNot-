import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/olympics_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/uselessness_meter.dart';

class PhoneUnlockScreen extends StatefulWidget {
  const PhoneUnlockScreen({super.key});

  @override
  State<PhoneUnlockScreen> createState() => _PhoneUnlockScreenState();
}

class _PhoneUnlockScreenState extends State<PhoneUnlockScreen> {
  bool _isLocked = true;
  int _unlockAttempts = 0;
  final Stopwatch _stopwatch = Stopwatch();
  double _lastTimeSec = 0.0;
  double _bestTimeSec = 999.0;
  String _biometricStatus = 'TAP BIOMETRIC TO UNLOCK';

  void _handleUnlockTap() {
    final provider = context.read<OlympicsProvider>();
    if (_isLocked) {
      // Unlock
      _stopwatch.reset();
      _stopwatch.start();
      setState(() {
        _isLocked = false;
        _biometricStatus = 'UNLOCKED! QUICK, LOCK IT AGAIN!';
      });
    } else {
      // Lock again
      _stopwatch.stop();
      _unlockAttempts++;
      _lastTimeSec = _stopwatch.elapsedMilliseconds / 1000.0;
      if (_lastTimeSec < _bestTimeSec) {
        _bestTimeSec = _lastTimeSec;
      }
      setState(() {
        _isLocked = true;
        _biometricStatus = 'LOCKED! UNLOCK AGAIN!';
      });

      provider.logAttempt('phone_unlock');
      if (_unlockAttempts >= 5) {
        provider.awardMedal('phone_unlock', MedalType.gold);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📱 Phone Unlocking Sprint'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const UselessnessMeter(
              statusText: 'Unlocking phone for no notification whatsoever.',
            ),
            const SizedBox(height: 16),
            NeoCard(
              backgroundColor: Colors.white,
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
                        child: const Text('⚡ 0.83 sec', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Phone mock graphic
                  Container(
                    width: 220,
                    height: 380,
                    decoration: BoxDecoration(
                      color: _isLocked ? const Color(0xFF1E1E24) : AppTheme.cyanAccent,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: AppTheme.borderColor, width: 4),
                      boxShadow: const [
                        BoxShadow(color: AppTheme.borderColor, offset: Offset(4, 4)),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Notch
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          width: 80,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        // Display content
                        Column(
                          children: [
                            Icon(
                              _isLocked ? Icons.lock_rounded : Icons.lock_open_rounded,
                              size: 54,
                              color: _isLocked ? Colors.white : AppTheme.darkText,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _isLocked ? '12:00 PM' : 'NO NEW NOTIFICATIONS',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                                color: _isLocked ? Colors.white : AppTheme.darkText,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _biometricStatus,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: _isLocked ? Colors.white70 : AppTheme.darkText,
                              ),
                            ),
                          ],
                        ),
                        // Action button
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GestureDetector(
                            onTap: _handleUnlockTap,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                              decoration: BoxDecoration(
                                color: _isLocked ? AppTheme.yellowAccent : AppTheme.pinkAccent,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppTheme.borderColor, width: 3),
                              ),
                              child: Center(
                                child: Text(
                                  _isLocked ? '👆 SCAN FINGERPRINT' : '🔒 LOCK PHONE',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                    color: _isLocked ? AppTheme.darkText : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    alignment: WrapAlignment.spaceAround,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _statBox('Attempts', '$_unlockAttempts'),
                      _statBox('Last Speed', _lastTimeSec > 0 ? '${_lastTimeSec.toStringAsFixed(2)}s' : '--'),
                      _statBox('Best Speed', _bestTimeSec < 900 ? '${_bestTimeSec.toStringAsFixed(2)}s' : '--'),
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

  Widget _statBox(String title, String val) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.borderColor, width: 2),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 2),
          Text(val, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        ],
      ),
    );
  }
}
