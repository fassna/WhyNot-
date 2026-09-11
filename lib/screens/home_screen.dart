import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/olympics_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/breaking_news_ticker.dart';
import '../widgets/cute_avatar.dart';
import '../widgets/diploma_modal.dart';
import '../widgets/neo_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _triggerConfetti() {
    _confettiController.play();
  }

  void _showDiploma() {
    showDialog(
      context: context,
      builder: (_) => const DiplomaModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OlympicsProvider>();
    final athlete = provider.athlete;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Fake Breaking News Banner
                  const BreakingNewsTicker(),

                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Bar
                        _buildHeader(provider, athlete),
                        const SizedBox(height: 16),

                        // Opening Ceremony Banner
                        _buildOpeningCeremonyBanner(context),
                        const SizedBox(height: 24),

                        // Tasks / Events Section Title
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.spaceBetween,
                          children: [
                            const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('🎪 ', style: TextStyle(fontSize: 22)),
                                Text(
                                  'THE 11 SACRED DISCIPLINES',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.greenAccent,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppTheme.borderColor, width: 2),
                              ),
                              child: const Text(
                                'STAGE: 100% UNPRODUCTIVE ✅',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Waste valuable minutes of your life to earn 100% genuine useless medals.',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                        ),
                        const SizedBox(height: 16),

                        // Grid of Events
                        _buildEventsGrid(context, provider.events),
                        const SizedBox(height: 28),

                        // Leaderboard
                        _buildLeaderboard(provider),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Top Confetti Cannon
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              colors: const [
                AppTheme.yellowAccent,
                AppTheme.pinkAccent,
                AppTheme.cyanAccent,
                AppTheme.greenAccent,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(OlympicsProvider provider, AthleteProfile athlete) {
    return NeoCard(
      backgroundColor: Colors.white,
      padding: 16,
      child: Column(
        children: [
          Row(
            children: [
              CuteAvatar(emoji: athlete.emoji, size: 52),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Text(
                          'whyNot! ',
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: AppTheme.darkText),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.pinkAccent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppTheme.borderColor, width: 1.5),
                          ),
                          child: const Text(
                            '2026 EDITION 🥔',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'USELESS OLYMPICS™ - "Where absolutely nothing matters."',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.pinkAccent),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEA),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.borderColor, width: 1.5),
                      ),
                      child: Text(
                        (athlete.whoAmIStatement).isEmpty
                            ? '🛋️ Professional at doing absolutely nothing.'
                            : athlete.whoAmIStatement,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.darkText),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, thickness: 2, color: AppTheme.borderColor),
          const SizedBox(height: 12),
          // Stats Row
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.start,
            children: [
              // Athlete Info Box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.cyanAccent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.borderColor, width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('CHAMPION: ', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    Text(athlete.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
              // Delegation Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.yellowAccent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.borderColor, width: 2),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: provider.delegations.contains(athlete.delegation)
                        ? athlete.delegation
                        : provider.delegations.first,
                    isDense: true,
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: AppTheme.darkText),
                    items: provider.delegations.map((d) {
                      return DropdownMenuItem(value: d, child: Text(d));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) provider.setDelegation(val);
                    },
                  ),
                ),
              ),
              // Wasted Time Box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.borderColor, width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('WASTED TIME ⏳ ', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    Text(
                      '${(athlete.wastedSeconds ~/ 60)}m ${athlete.wastedSeconds % 60}s',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppTheme.pinkAccent),
                    ),
                  ],
                ),
              ),
              // Futility Level
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8FCC2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.borderColor, width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('FUTILITY LEVEL 📉 ', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    Text(
                      '${athlete.overallUselessness}%',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppTheme.greenAccent),
                    ),
                  ],
                ),
              ),
              // Medal tally box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.borderColor, width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('🥇 ${athlete.goldMedals} ', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    Text('🥈 ${athlete.silverMedals} ', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    Text('🥉 ${athlete.bronzeMedals}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              // Sound toggle
              ElevatedButton.icon(
                onPressed: () => provider.toggleAudio(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: provider.audioEnabled ? AppTheme.greenAccent : Colors.grey.shade300,
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: AppTheme.borderColor, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                icon: Text(provider.audioEnabled ? '🔊' : '🔇', style: const TextStyle(fontSize: 13)),
                label: Text(
                  provider.audioEnabled ? 'MEME AUDIO: ON' : 'MEME AUDIO: OFF',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
              // Diploma Trigger Button
              ElevatedButton.icon(
                onPressed: _showDiploma,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.pinkAccent,
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: AppTheme.borderColor, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                icon: const Text('📜', style: TextStyle(fontSize: 14)),
                label: const Text('DIPLOMA OF SHAME', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOpeningCeremonyBanner(BuildContext context) {
    return NeoCard(
      backgroundColor: const Color(0xFFFFFBEA),
      padding: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.yellowAccent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.borderColor, width: 2),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('🏟️ ', style: TextStyle(fontSize: 12)),
                    Text(
                      'OFFICIAL OPENING CEREMONY',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const Text('🔥 THE SACRED POTATO FLAME IS LIT',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppTheme.orangeAccent)),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'WELCOME TO THE ARENA OF PURE FUTILITY! 💀',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppTheme.darkText,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Forget heavy lifting and marathon running. Here we celebrate professional procrastinators, excessive browser tab hoarders, and people who stare into the fridge hoping new snacks have spawned by magic.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ElevatedButton.icon(
                onPressed: _triggerConfetti,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.yellowAccent,
                  foregroundColor: AppTheme.darkText,
                  side: const BorderSide(color: AppTheme.borderColor, width: 2.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
                icon: const Text('🎉', style: TextStyle(fontSize: 15)),
                label: const Text('CONFETTI TSUNAMI', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
              ),
              ElevatedButton.icon(
                onPressed: _showDiploma,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.purpleAccent,
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: AppTheme.borderColor, width: 2.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
                icon: const Text('🏅', style: TextStyle(fontSize: 15)),
                label: const Text('CLAIM UNMERITED MEDAL', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventsGrid(BuildContext context, List<UselessEvent> events) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 1;
        if (constraints.maxWidth > 1000) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth > 600) {
          crossAxisCount = 2;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: events.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            mainAxisExtent: 220,
          ),
          itemBuilder: (context, index) {
            final event = events[index];
            return _buildEventCard(context, event, index + 1);
          },
        );
      },
    );
  }

  Widget _buildEventCard(BuildContext context, UselessEvent event, int indexNum) {
    final textColor = event.cardColor.computeLuminance() > 0.45 ? AppTheme.darkText : Colors.white;

    return NeoCard(
      backgroundColor: Colors.white,
      padding: 14,
      onTap: () {
        Navigator.of(context).pushNamed(event.routeName);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: event.cardColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.borderColor, width: 1.5),
                    ),
                    child: Text(
                      'EVENT #${indexNum.toString().padLeft(2, '0')}',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10, color: textColor),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      event.categoryTag,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(event.emoji, style: const TextStyle(fontSize: 26)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      event.title,
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                event.subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'RECORD: ${event.worldRecord}',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  if (event.medalEarned)
                    const Text('🥇 MEDAL WON', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.pinkAccent)),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: event.cardColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.borderColor, width: 2),
                ),
                child: Center(
                  child: Text(
                    'ENTER EVENT NOW 🚀',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: textColor),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboard(OlympicsProvider provider) {
    return NeoCard(
      backgroundColor: Colors.white,
      padding: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceBetween,
            children: [
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🌍 ', style: TextStyle(fontSize: 20)),
                  Text(
                    'GLOBAL MEDAL STANDINGS',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.yellowAccent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.borderColor, width: 1.5),
                ),
                child: const Text('HIGHLY CORRUPTED 💛', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 14,
              horizontalMargin: 8,
              headingRowHeight: 36,
              dataRowMinHeight: 40,
              columns: const [
                DataColumn(label: Text('RANK', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11))),
                DataColumn(label: Text('DELEGATION', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11))),
                DataColumn(label: Text('🥇 GOLD', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11))),
                DataColumn(label: Text('🥈 SILVER', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11))),
                DataColumn(label: Text('🥉 BRONZE', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11))),
                DataColumn(label: Text('SNOOZES', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11))),
              ],
              rows: provider.leaderboard.map((entry) {
                return DataRow(cells: [
                  DataCell(Text('#0${entry.rank}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                  DataCell(Row(
                    children: [
                      Text(entry.flagEmoji, style: const TextStyle(fontSize: 15)),
                      const SizedBox(width: 4),
                      Text(entry.delegation, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                    ],
                  )),
                  DataCell(Text('${entry.gold}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.orangeAccent))),
                  DataCell(Text('${entry.silver}', style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text('${entry.bronze}', style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(entry.totalTimeWasted, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

}
