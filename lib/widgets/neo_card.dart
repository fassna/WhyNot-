import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NeoCard extends StatefulWidget {
  final Widget child;
  final Color backgroundColor;
  final VoidCallback? onTap;
  final double padding;
  final double borderRadius;
  final double shadowOffset;

  const NeoCard({
    super.key,
    required this.child,
    this.backgroundColor = AppTheme.cardBg,
    this.onTap,
    this.padding = 16.0,
    this.borderRadius = AppTheme.borderRadius,
    this.shadowOffset = 4.0,
  });

  @override
  State<NeoCard> createState() => _NeoCardState();
}

class _NeoCardState extends State<NeoCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final offset = _isPressed ? 1.0 : widget.shadowOffset;

    return GestureDetector(
      onTapDown: widget.onTap != null ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: widget.onTap != null ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: widget.onTap != null ? () => setState(() => _isPressed = false) : null,
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: EdgeInsets.all(widget.padding),
        decoration: AppTheme.neoBoxDecoration(
          color: widget.backgroundColor,
          borderRadius: widget.borderRadius,
          shadowOffset: offset,
        ),
        child: widget.child,
      ),
    );
  }
}
