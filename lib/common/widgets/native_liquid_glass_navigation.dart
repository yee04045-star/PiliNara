import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Embeds the native iOS tab bar while preserving the existing Flutter pages.
/// The Material fallback keeps Android, desktop, older iOS, and tests unchanged.
class NativeLiquidGlassNavigation extends StatefulWidget {
  const NativeLiquidGlassNavigation({
    required this.labels,
    required this.symbols,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final List<String> labels;
  final List<String> symbols;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  State<NativeLiquidGlassNavigation> createState() =>
      _NativeLiquidGlassNavigationState();
}

class _NativeLiquidGlassNavigationState
    extends State<NativeLiquidGlassNavigation> {
  MethodChannel? _channel;

  void _created(int id) {
    final channel = MethodChannel('piliplus/liquid_glass_navigation/$id');
    channel.setMethodCallHandler((call) async {
      if (call.method == 'selected' && call.arguments is int) {
        widget.onSelected(call.arguments as int);
      }
    });
    _channel = channel;
  }

  @override
  void didUpdateWidget(covariant NativeLiquidGlassNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_channel == null) return;
    if (oldWidget.selectedIndex != widget.selectedIndex ||
        !listEquals(oldWidget.labels, widget.labels) ||
        !listEquals(oldWidget.symbols, widget.symbols)) {
      _channel!.invokeMethod<void>('update', {
        'labels': widget.labels,
        'symbols': widget.symbols,
        'selectedIndex': widget.selectedIndex,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: 84,
      child: UiKitView(
        viewType: 'piliplus/liquid_glass_navigation',
        creationParams: {
          'labels': widget.labels,
          'symbols': widget.symbols,
          'selectedIndex': widget.selectedIndex,
        },
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _created,
      ),
    );
  }
}
