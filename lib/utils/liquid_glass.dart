import 'dart:io' show Platform;
import 'dart:ui' show ImageFilter;

import 'package:PiliPlus/common/widgets/native_liquid_glass_surface.dart';
import 'package:material_ui/material_ui.dart';

/// Runtime helpers for the iOS 26 Liquid Glass visual treatment.
///
/// Flutter does not expose Apple's native `glassEffect` API directly. This
/// utility provides a restrained Flutter equivalent for custom surfaces while
/// allowing standard platform components to keep their system appearance.
abstract final class LiquidGlass {
  static bool get isIOS26OrNewer {
    if (!Platform.isIOS) return false;
    final match = RegExp(r'(?:^|[^0-9])(\d+)(?:\.\d+)?')
        .firstMatch(Platform.operatingSystemVersion);
    final major = int.tryParse(match?.group(1) ?? '0') ?? 0;
    return major >= 26;
  }

  static Color fill(ColorScheme scheme, {required bool isDark}) =>
      scheme.surface.withValues(alpha: isDark ? 0.72 : 0.78);

  static Color border(ColorScheme scheme, {required bool isDark}) =>
      scheme.onSurface.withValues(alpha: isDark ? 0.16 : 0.10);

  static final ImageFilter blur = ImageFilter.blur(sigmaX: 24, sigmaY: 24);
}

/// A reusable translucent surface for custom Flutter controls and panels.
///
/// Use this only for important functional surfaces; avoid wrapping an entire
/// screen so that content remains legible and the hierarchy stays clear.
class LiquidGlassPanel extends StatelessWidget {
  const LiquidGlassPanel({
    required this.child,
    super.key,
    this.borderRadius = const BorderRadius.all(Radius.circular(22)),
    this.padding,
    this.margin,
    this.clipBehavior = Clip.antiAlias,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final enabled = LiquidGlass.isIOS26OrNewer;
    final scheme = theme.colorScheme;
    final fill = enabled
        ? LiquidGlass.fill(scheme, isDark: isDark)
        : scheme.surface;
    final border = enabled
        ? LiquidGlass.border(scheme, isDark: isDark)
        : Colors.transparent;

    final flutterGlassChild = ClipRRect(
      borderRadius: borderRadius,
      clipBehavior: clipBehavior,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: fill,
            borderRadius: borderRadius,
            border: Border.all(color: border),
          ),
          child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
        ),
      ),
    );

    final nativeGlassChild = ClipRRect(
      borderRadius: borderRadius,
      clipBehavior: clipBehavior,
      child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
    );

    Widget surface = enabled
        ? NativeLiquidGlassSurface(
            radius: borderRadius.topLeft.x,
            interactive: true,
            child: nativeGlassChild,
          )
        : flutterGlassChild;
    if (margin != null) surface = Padding(padding: margin!, child: surface);
    return surface;
  }
}
