import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/olympics_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/neo_card.dart';
import '../../widgets/uselessness_meter.dart';

class UnnecessaryRefreshScreen extends StatefulWidget {
  const UnnecessaryRefreshScreen({super.key});

  @override
  State<UnnecessaryRefreshScreen> createState() => _UnnecessaryRefreshScreenState();
}

class _UnnecessaryRefreshScreenState extends State<UnnecessaryRefreshScreen> {
  int _refreshes = 0;
  bool _isRefreshing = false;

  final List<String> _uselessMessages = [
    "Checking if someone replied... Nope.",
    "Page still looks identical.",
    "Internet speed: 500Mbps. Info gained: 0.",
    "Server responded: 'Why are you doing this?'",
    "Refreshing intensified.",
    "47th attempt. Still no notifications.",
    "The page is begging you to stop.",
  ];

  String get _currentMsg => _uselessMessages[_refreshes % _uselessMessages.length];

  void _handleRefresh() {
    final provider = context.read<OlympicsProvider>();
    setState(() {
      _isRefreshing = true;
      _refreshes++;
    });

    provider.logAttempt('refresh');

    if (_refreshes == 10) {
      provider.awardMedal('refresh', MedalType.bronze);
    } else if (_refreshes == 30) {
      provider.awardMedal('refresh', MedalType.silver);
    } else if (_refreshes == 50) {
      provider.awardMedal('refresh', MedalType.gold);
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _isRefreshing = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔄 Unnecessary Refresh Sprint'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const UselessnessMeter(
              statusText: 'Information gained: Exactly 0.000 bits.',
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
                        child: const Text('🏆 84 Refreshes', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Fake browser bar
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.borderColor, width: 2),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.circle, color: Colors.red, size: 12),
                            const SizedBox(width: 4),
                            const Icon(Icons.circle, color: Colors.amber, size: 12),
                            const SizedBox(width: 4),
                            const Icon(Icons.circle, color: Colors.green, size: 12),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: AppTheme.borderColor, width: 1.5),
                                ),
                                child: const Text(
                                  'https://useless-olympics.org/nothing-new',
                                  style: TextStyle(fontSize: 11, fontFamily: 'monospace'),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 140,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.borderColor, width: 1.5),
                          ),
                          child: _isRefreshing
                              ? const Center(
                                  child: CircularProgressIndicator(color: AppTheme.pinkAccent),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('🥔', style: TextStyle(fontSize: 40)),
                                    const SizedBox(height: 8),
                                    Text(
                                      _currentMsg,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _handleRefresh,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.yellowAccent,
                      foregroundColor: AppTheme.darkText,
                      side: const BorderSide(color: AppTheme.borderColor, width: 3),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    icon: const Text('🔄', style: TextStyle(fontSize: 22)),
                    label: const Text(
                      'SPAM REFRESH NOW!',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    alignment: WrapAlignment.spaceAround,
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _stat('Furious Refreshes', '$_refreshes'),
                      _stat('Info Gained', '0.000 bits'),
                      _stat('Braincells Lost', '$_refreshes'),
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

  Widget _stat(String label, String val) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(val, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
      ],
    );
  }
}
