import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/olympics_provider.dart';
import '../theme/app_theme.dart';

class BreakingNewsTicker extends StatefulWidget {
  const BreakingNewsTicker({super.key});

  @override
  State<BreakingNewsTicker> createState() => _BreakingNewsTickerState();
}

class _BreakingNewsTickerState extends State<BreakingNewsTicker> {
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      final news = context.read<OlympicsProvider>().newsList;
      if (news.isNotEmpty && mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % news.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newsList = context.watch<OlympicsProvider>().newsList;
    if (newsList.isEmpty) return const SizedBox.shrink();

    final currentItem = newsList[_currentIndex % newsList.length];

    return Container(
      width: double.infinity,
      color: AppTheme.yellowAccent,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.pinkAccent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppTheme.borderColor, width: 2),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🚨 ', style: TextStyle(fontSize: 12)),
                Text(
                  'FAKE BREAKING NEWS',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 1.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: Text(
                currentItem.headline,
                key: ValueKey<String>(currentItem.id),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppTheme.darkText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
