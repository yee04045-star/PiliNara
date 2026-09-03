import 'package:PiliPlus/common/widgets/native_liquid_glass_surface.dart';
import 'package:flutter/material.dart';

class LiquidGlassHud extends StatelessWidget {
  final Widget child;
  const LiquidGlassHud({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return NativeLiquidGlassSurface(
      radius: 22,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: child,
      ),
    );
  }
}
