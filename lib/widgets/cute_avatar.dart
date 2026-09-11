import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CuteAvatar extends StatelessWidget {
  final String emoji;
  final double size;
  final Color backgroundColor;

  const CuteAvatar({
    super.key,
    required this.emoji,
    this.size = 50.0,
    this.backgroundColor = AppTheme.yellowAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.borderColor, width: 2.5),
        boxShadow: const [
          BoxShadow(color: AppTheme.borderColor, offset: Offset(2, 2)),
        ],
      ),
      child: Center(
        child: Text(
          emoji,
          style: TextStyle(fontSize: size * 0.5),
        ),
      ),
    );
  }
}
