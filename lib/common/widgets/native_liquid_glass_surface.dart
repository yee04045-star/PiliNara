import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Places a real iOS 26 SwiftUI Liquid Glass surface behind Flutter content.
///
/// On iOS 26 the native platform view uses SwiftUI's `glassEffect`, while
/// other platforms simply return the child unchanged.
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
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: UiKitView(
              viewType: 'piliplus/native_liquid_glass_surface',
              creationParams: {
                'radius': radius,
                'interactive': interactive,
              },
              creationParamsCodec: const StandardMessageCodec(),
            ),
          ),
        ),
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
