import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/olympics_provider.dart';
import 'screens/events/alarm_snooze_screen.dart';
import 'screens/events/cursor_olympics_screen.dart';
import 'screens/events/door_opening_screen.dart';
import 'screens/events/fastest_lol_screen.dart';
import 'screens/events/fridge_staring_screen.dart';
import 'screens/events/phone_unlock_screen.dart';
import 'screens/events/sock_matching_screen.dart';
import 'screens/events/staring_competition_screen.dart';
import 'screens/events/unnecessary_refresh_screen.dart';
import 'screens/events/why_did_i_open_this_screen.dart';
import 'screens/events/yawn_detection_screen.dart';
import 'screens/home_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/welcome_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => OlympicsProvider(),
      child: const WhyNotUselessOlympicsApp(),
    ),
  );
}

class WhyNotUselessOlympicsApp extends StatelessWidget {
  const WhyNotUselessOlympicsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'whyNot! - USELESS OLYMPICS™ 2026',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/registration': (context) => const RegistrationScreen(),
        '/home': (context) => const HomeScreen(),
        '/phone_unlock': (context) => const PhoneUnlockScreen(),
        '/refresh': (context) => const UnnecessaryRefreshScreen(),
        '/staring': (context) => const StaringCompetitionScreen(),
        '/door': (context) => const DoorOpeningScreen(),
        '/why_opened': (context) => const WhyDidIOpenThisScreen(),
        '/fastest_lol': (context) => const FastestLolScreen(),
        '/cursor_maze': (context) => const CursorOlympicsScreen(),
        '/alarm_snooze': (context) => const AlarmSnoozeScreen(),
        '/yawn_detect': (context) => const YawnDetectionScreen(),
        '/sock_match': (context) => const SockMatchingScreen(),
        '/fridge_stare': (context) => const FridgeStaringScreen(),
      },
    );
  }
}
