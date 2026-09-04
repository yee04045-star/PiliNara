import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

/// Safe Liquid Glass surface for Flutter content.
///
/// IMPORTANT: A full-size UiKitView cannot be used as a wrapper around a
/// Flutter subtree. Flutter's iOS platform-view composition can place the
/// native view above the Flutter compositor even when the Dart widget is
/// visually below it. That can cover the Flutter frame and produce a
/// launch-screen -> gray/blank app with blocked input.
///
/// Until the native glass overlay is attached at the root UIKit level, keep
/// this widget entirely in the Flutter compositor. This preserves scrolling,
/// gestures and rendering. The native iOS 26 glass implementation remains
/// available in NativeLiquidGlassView.swift for the later root-overlay path.
class NativeLiquidGlassSurface extends StatelessWidget {
  const NativeLiquidGlassSurface({
    required this.child,
    super.key,
    this.radius = 22,
    this.interactive = true,
  });

  final Widget child;
  final double radius;
  final bool interactive;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: (dark ? Colors.black : Colors.white).withValues(alpha: 0.28),
            border: Border.all(
              color: (dark ? Colors.white : Colors.black).withValues(alpha: 0.12),
            ),
            borderRadius: BorderRadius.circular(radius),
          ),
          child: child,
        ),
      ),
    );
  }
}
