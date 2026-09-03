import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A small iOS 26 native Liquid Glass layer.
///
/// The native platform view is deliberately placed BELOW the Flutter child.
/// This avoids a full-size UiKitView covering the Flutter compositor and
/// leaving the app on a gray/blank frame after the launch screen.
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
    if (defaultTargetPlatform != TargetPlatform.iOS || !_isIOS26OrNewer) {
      return child;
    }

    return Stack(
      fit: StackFit.passthrough,
      children: [
        Positioned.fill(
          child: UiKitView(
            viewType: 'piliplus/native_liquid_glass_surface',
            creationParams: {
              'radius': radius,
              'interactive': interactive,
            },
            creationParamsCodec: StandardMessageCodec(),
          ),
        ),
        child,
      ],
    );
  }

  static bool get _isIOS26OrNewer {
    if (!Platform.isIOS) return false;
    final match = RegExp(r'(?:^|[^0-9])(\d+)(?:\.\d+)?')
        .firstMatch(Platform.operatingSystemVersion);
    final major = int.tryParse(match?.group(1) ?? '0') ?? 0;
    return major >= 26;
  }
}
