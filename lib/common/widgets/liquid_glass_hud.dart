import 'dart:ui';
import 'package:flutter/material.dart';

class LiquidGlassHud extends StatelessWidget {
  final Widget child;
  const LiquidGlassHud({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .14),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: .22)),
          ),
          child: child,
        ),
      ),
    );
  }
}
