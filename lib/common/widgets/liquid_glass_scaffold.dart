import 'package:PiliPlus/common/widgets/native_liquid_glass_surface.dart';
import 'package:flutter/material.dart';

/// iOS 26 style glass container for top bars, search bars and floating controls.
class LiquidGlassSurface extends StatelessWidget {
  const LiquidGlassSurface({required this.child, super.key, this.radius = 24});
  final Widget child;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return NativeLiquidGlassSurface(
      radius: radius,
      child: child,
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
