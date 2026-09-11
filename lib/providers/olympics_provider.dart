import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/models.dart';

class OlympicsProvider extends ChangeNotifier {
  late AthleteProfile _athlete;
  Timer? _wastedTimer;
  bool _audioEnabled = true;

  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool get audioEnabled => _audioEnabled;

  void toggleAudio() {
    _audioEnabled = !_audioEnabled;
    if (_audioEnabled) {
      // Uncomment when you add background music
      // _bgmPlayer.play(AssetSource('audio/bgm.mp3'));
    } else {
      _bgmPlayer.pause();
    }
    notifyListeners();
  }

  void playSoundEffect(String assetPath) {
    if (_audioEnabled) {
      _sfxPlayer.play(AssetSource(assetPath));
    }
  }

  AthleteProfile get athlete => _athlete;

  final List<String> delegations = [
    '🥔 Couch Potatoes Republic',
    '🛌 Republic of Procrastiland',
    '🧠 Overthinking Federation',
    '🌴 Kerala Athlete Alliance',
    '⏰ Snooze Squad International',
    '🐱 Lazy Cat Confederation',
    '🐶 Silly Dog Union',
    '💻 Tab Hoarders United',
  ];

  final List<String> whoAmIOptions = [
    '🛋️ Professional at doing absolutely nothing.',
    '📶 Your wifi signal has more direction than me.',
    '⏱️ I came here to waste time professionally.',
    '📚 Someone who opened this website instead of studying.',
    '🎓 A highly qualified procrastinator.',
    '⏰ The reason ‘5 more minutes’ became 3 hours.',
    '🤷 Nobody important. Please continue. 😂',
    '🏅 I have no idea, but I deserve a medal.',
  ];

  late List<UselessEvent> _events;
  List<UselessEvent> get events => _events;

  final List<BreakingNews> _newsList = [
    BreakingNews(
      id: '1',
      headline:
          '🚨 BREAKING: Kerala athlete breaks world record for unnecessary refreshing! 84 refreshes. Page still unchanged 😭',
      emoji: '🔄',
      timeAgo: '2m ago',
    ),
    BreakingNews(
      id: '2',
      headline:
          '🥔 VAR confirms Couch Potato athlete remained completely unmoved for 9 consecutive hours.',
      emoji: '📺',
      timeAgo: '12m ago',
    ),
    BreakingNews(
      id: '3',
      headline:
          '🥱 NASA scientist inspects Useless Olympics: Confirms purpose remains strictly 0.00%.',
      emoji: '🚀',
      timeAgo: '25m ago',
    ),
    BreakingNews(
      id: '4',
      headline:
          '⏰ Snooze Champion hit snooze button 42 times and woke up in the next calendar year 🌅',
      emoji: '⏰',
      timeAgo: '1h ago',
    ),
    BreakingNews(
      id: '5',
      headline:
          '🧦 Sock Matching Grand Prix chaos: Athlete disqualified for suspecting identical socks were different colors.',
      emoji: '🧦',
      timeAgo: '2h ago',
    ),
  ];

  List<BreakingNews> get newsList => _newsList;

  final List<LeaderboardEntry> leaderboard = [
    LeaderboardEntry(
      rank: 1,
      delegation: 'Couch Potatoes Republic',
      flagEmoji: '🥔',
      gold: 0,
      silver: 0,
      bronze: 0,
      totalTimeWasted: '0 hrs',
    ),
    LeaderboardEntry(
      rank: 2,
      delegation: 'Republic of Procrastiland',
      flagEmoji: '🛌',
      gold: 0,
      silver: 0,
      bronze: 0,
      totalTimeWasted: '0 hrs',
    ),
    LeaderboardEntry(
      rank: 3,
      delegation: 'Overthinking Federation',
      flagEmoji: '🧠',
      gold: 0,
      silver: 0,
      bronze: 0,
      totalTimeWasted: '0 hrs',
    ),
    LeaderboardEntry(
      rank: 4,
      delegation: 'Tab Hoarders United',
      flagEmoji: '💻',
      gold: 0,
      silver: 0,
      bronze: 0,
      totalTimeWasted: '0 hrs',
    ),
    LeaderboardEntry(
      rank: 5,
      delegation: 'Kerala Athlete Alliance',
      flagEmoji: '🌴',
      gold: 0,
      silver: 0,
      bronze: 0,
      totalTimeWasted: '0 hrs',
    ),
  ];

  OlympicsProvider() {
    _athlete = AthleteProfile(
      name: 'Champion Fasna',
      delegation: '🥔 Couch Potatoes Republic',
      emoji: '🥔',
      whoAmIStatement: '🛋️ Professional at doing absolutely nothing.',
    );

    _initEvents();
    _startWastedTimer();
    _initAudio();
  }

  void _initAudio() async {
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    if (_audioEnabled) {
      // Uncomment and add asset when ready
      // _bgmPlayer.play(AssetSource('audio/bgm.mp3'));
    }
  }

  void _initEvents() {
    _events = [
      UselessEvent(
        id: 'phone_unlock',
        title: 'Phone Unlocking Speed Sprint 📱',
        subtitle: 'How fast can you unlock your phone & lock it again?',
        emoji: '📱',
        categoryTag: 'DIGITAL REFLEXES',
        cardColor: const Color(0xFFFFE500),
        worldRecord: '0.83 sec',
        routeName: '/phone_unlock',
      ),
      UselessEvent(
        id: 'refresh',
        title: 'Unnecessary Refresh Sprint 🔄',
        subtitle: 'Refresh a webpage when absolutely nothing is happening.',
        emoji: '🔄',
        categoryTag: 'POINTLESS CLICKING',
        cardColor: const Color(0xFF4CC9F0),
        worldRecord: '84 Refreshes',
        routeName: '/refresh',
      ),
      UselessEvent(
        id: 'staring',
        title: 'Blank Screen Staring Marathon 👀',
        subtitle: 'Stare at a void screen. System tracks blink count.',
        emoji: '👀',
        categoryTag: 'SUPREME IDLENESS',
        cardColor: const Color(0xFFFF758F),
        worldRecord: '37.4 seconds',
        routeName: '/staring',
      ),
      UselessEvent(
        id: 'door',
        title: 'Door Opening Championship 🚪',
        subtitle: 'Open and close a door as many times as possible.',
        emoji: '🚪',
        categoryTag: 'PURPOSELESS ARCHITECTURE',
        cardColor: const Color(0xFF38B000),
        worldRecord: '124 door opens',
        routeName: '/door',
      ),
      UselessEvent(
        id: 'why_opened',
        title: '“Why Did I Open This?” 🧠',
        subtitle: 'An app opens a random tab. Try to remember why after 10s.',
        emoji: '🧠',
        categoryTag: 'MEMORY OBLITERATION',
        cardColor: const Color(0xFFFF9F1C),
        worldRecord: 'Forgotten in 0.4s',
        routeName: '/why_opened',
      ),
      UselessEvent(
        id: 'fastest_lol',
        title: 'Fastest “LOL” Speedrun ⌨️',
        subtitle: 'Type: lol, lmao, 😂, haha, hehe at maximum velocity.',
        emoji: '⌨️',
        categoryTag: 'MEME KEYBOARDING',
        cardColor: const Color(0xFFB5179E),
        worldRecord: '0.41 sec',
        routeName: '/fastest_lol',
      ),
      UselessEvent(
        id: 'cursor_maze',
        title: 'Pet Cursor Olympics 🖱️🐶',
        subtitle:
            'Guide cute dog cursor through an impossible maze for 0 reward.',
        emoji: '🐶',
        categoryTag: 'PURE SUFFERING',
        cardColor: const Color(0xFF70D6FF),
        worldRecord: '100% Wasted',
        routeName: '/cursor_maze',
      ),
      UselessEvent(
        id: 'alarm_snooze',
        title: 'Alarm Snooze Championship ⏰',
        subtitle: 'Spam SNOOZE 20 times. 🌅 Congratulations. It is tomorrow.',
        emoji: '⏰',
        categoryTag: 'CHRONIC PROCRASTINATION',
        cardColor: const Color(0xFFFF595E),
        worldRecord: '20 Snoozes',
        routeName: '/alarm_snooze',
      ),
      UselessEvent(
        id: 'yawn_detect',
        title: 'Yawn Detection Arena 🥱🦥',
        subtitle: 'Camera watches player & lazy sloth. Yawn to win GOLD! 🥇',
        emoji: '🦥',
        categoryTag: 'BIOMETRIC EXHAUSTION',
        cardColor: const Color(0xFFFFCA3A),
        worldRecord: 'Gold Medal Yawn',
        routeName: '/yawn_detect',
      ),
      UselessEvent(
        id: 'sock_match',
        title: 'Sock Matching Grand Prix 🧦',
        subtitle: 'Two identical socks. AI gives random erroneous verdicts.',
        emoji: '🧦',
        categoryTag: 'ILLUSION OF CHOICE',
        cardColor: const Color(0xFF8AC926),
        worldRecord: '0% Accuracy',
        routeName: '/sock_match',
      ),
      UselessEvent(
        id: 'fridge_stare',
        title: 'Fridge Staring Simulator 🧊',
        subtitle: 'Open fridge 50 times hoping new snacks magically spawned.',
        emoji: '🧊',
        categoryTag: 'CULINARY DELUSION',
        cardColor: const Color(0xFF1982C4),
        worldRecord: '50 Opens / 0 Snacks',
        routeName: '/fridge_stare',
      ),
    ];
  }

  void _startWastedTimer() {
    _wastedTimer?.cancel();
    _wastedTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _athlete.wastedSeconds++;
      _athlete.overallUselessness += 0.01;
      if (_athlete.overallUselessness > 100.0)
        _athlete.overallUselessness = 100.0;
      notifyListeners();
    });
  }

  void setAthleteName(String name) {
    _athlete.name = name;
    notifyListeners();
  }

  void setWhoAmI(String statement) {
    _athlete.whoAmIStatement = statement;
    notifyListeners();
  }

  void setDelegation(String delegation) {
    _athlete.delegation = delegation;
    if (delegation.contains('🥔')) {
      _athlete.emoji = '🥔';
    } else if (delegation.contains('🛌')) {
      _athlete.emoji = '🛌';
    } else if (delegation.contains('🧠')) {
      _athlete.emoji = '🧠';
    } else if (delegation.contains('🌴')) {
      _athlete.emoji = '🌴';
    } else if (delegation.contains('⏰')) {
      _athlete.emoji = '⏰';
    } else if (delegation.contains('🐱')) {
      _athlete.emoji = '🐱';
    } else if (delegation.contains('🐶')) {
      _athlete.emoji = '🐶';
    } else {
      _athlete.emoji = '💻';
    }
    notifyListeners();
  }

  void awardMedal(String eventId, MedalType medal) {
    final event = _events.firstWhere((e) => e.id == eventId);
    event.userAttempts++;
    if (!event.medalEarned) {
      playSoundEffect('audio/win.mp3');
      event.medalEarned = true;
      if (medal == MedalType.gold) {
        _athlete.goldMedals++;
        _athlete.overallUselessness += 15.0;
      } else if (medal == MedalType.silver) {
        _athlete.silverMedals++;
        _athlete.overallUselessness += 10.0;
      } else if (medal == MedalType.bronze) {
        _athlete.bronzeMedals++;
        _athlete.overallUselessness += 5.0;
      }
      if (_athlete.overallUselessness > 100.0)
        _athlete.overallUselessness = 100.0;

      final delegationIndex = leaderboard.indexWhere(
        (entry) => _athlete.delegation.contains(entry.delegation),
      );
      if (delegationIndex != -1) {
        final currentEntry = leaderboard[delegationIndex];
        leaderboard[delegationIndex] = LeaderboardEntry(
          rank: currentEntry.rank,
          delegation: currentEntry.delegation,
          flagEmoji: currentEntry.flagEmoji,
          gold: currentEntry.gold + (medal == MedalType.gold ? 1 : 0),
          silver: currentEntry.silver + (medal == MedalType.silver ? 1 : 0),
          bronze: currentEntry.bronze + (medal == MedalType.bronze ? 1 : 0),
          totalTimeWasted: currentEntry.totalTimeWasted,
        );
      }
    }

    addNews(
      '🏅 ${_athlete.name} (${_athlete.delegation}) just won a ${medal.name.toUpperCase()} medal in ${event.title}!',
      event.emoji,
    );
    notifyListeners();
  }

  void logAttempt(String eventId) {
    final event = _events.firstWhere((e) => e.id == eventId);
    event.userAttempts++;
    _athlete.overallUselessness += 0.5;
    if (_athlete.overallUselessness > 100.0)
      _athlete.overallUselessness = 100.0;
    notifyListeners();
  }

  void addNews(String headline, String emoji) {
    _newsList.insert(
      0,
      BreakingNews(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        headline: '🚨 BREAKING: $headline',
        emoji: emoji,
        timeAgo: 'Just now',
      ),
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _wastedTimer?.cancel();
    _bgmPlayer.dispose();
    _sfxPlayer.dispose();
    super.dispose();
  }
}
