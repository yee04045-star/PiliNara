import 'dart:ui';
import 'package:flutter/material.dart';

class GlassSheet extends StatelessWidget {
  final Widget child;
  const GlassSheet({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: .16)),
          child: child,
        ),
      ),
    );
  }
}
