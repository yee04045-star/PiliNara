import 'dart:ui';
import 'package:flutter/material.dart';

class LiquidGlassHud extends StatelessWidget {
  final Widget child;
  const LiquidGlassHud({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .16),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white.withValues(alpha: .22),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
