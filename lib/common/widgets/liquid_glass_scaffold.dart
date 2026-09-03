import 'dart:ui';
import 'package:flutter/material.dart';

/// iOS 26 style glass container for top bars, search bars and floating controls.
class LiquidGlassSurface extends StatelessWidget {
  const LiquidGlassSurface({required this.child, super.key, this.radius = 24});
  final Widget child;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: (dark ? Colors.black : Colors.white).withValues(alpha: .28),
            border: Border.all(
              color: Colors.white.withValues(alpha: .18),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class LiquidGlassScrollScaffold extends StatelessWidget {
  const LiquidGlassScrollScaffold({
    required this.body,
    super.key,
    this.header,
  });
  final Widget body;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        if (header != null)
          SliverAppBar(
            pinned: true,
            floating: true,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: LiquidGlassSurface(child: header!),
          ),
        SliverToBoxAdapter(child: body),
      ],
    );
  }
}
