import 'package:flutter/material.dart';

enum MedalType { gold, silver, bronze, none }

class AthleteProfile {
  String name;
  String delegation; // e.g. 🥔 Couch Potatoes Republic
  String emoji; // e.g. 🥔, 🐱, 🐶, 🦥
  String whoAmIStatement;
  int goldMedals;
  int silverMedals;
  int bronzeMedals;
  int wastedSeconds;
  double overallUselessness; // e.g. 98.7%

  AthleteProfile({
    String? name,
    String? delegation,
    String? emoji,
    String? whoAmIStatement,
    this.goldMedals = 0,
    this.silverMedals = 0,
    this.bronzeMedals = 0,
    this.wastedSeconds = 0,
    this.overallUselessness = 0.0,
  })  : name = name ?? 'Champion Fasna',
        delegation = delegation ?? '🥔 Couch Potatoes Republic',
        emoji = emoji ?? '🥔',
        whoAmIStatement = whoAmIStatement ?? '🛋️ Professional at doing absolutely nothing.';

  int get totalMedals => goldMedals + silverMedals + bronzeMedals;
}

class UselessEvent {
  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final String categoryTag; // e.g. "LOW-IQ COMPUTING", "PHILOSOPHICAL CRISIS"
  final Color cardColor;
  final String worldRecord;
  final String routeName;
  int userAttempts;
  bool medalEarned;

  UselessEvent({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.categoryTag,
    required this.cardColor,
    required this.worldRecord,
    required this.routeName,
    this.userAttempts = 0,
    this.medalEarned = false,
  });
}

class BreakingNews {
  final String id;
  final String headline;
  final String emoji;
  final String timeAgo;

  BreakingNews({
    required this.id,
    required this.headline,
    required this.emoji,
    required this.timeAgo,
  });
}

class LeaderboardEntry {
  final int rank;
  final String delegation;
  final String flagEmoji;
  final int gold;
  final int silver;
  final int bronze;
  final String totalTimeWasted;

  LeaderboardEntry({
    required this.rank,
    required this.delegation,
    required this.flagEmoji,
    required this.gold,
    required this.silver,
    required this.bronze,
    required this.totalTimeWasted,
  });
}
