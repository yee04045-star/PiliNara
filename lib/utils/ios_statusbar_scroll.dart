
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Bridges iOS status-bar taps to Flutter scroll views.
abstract final class IOSStatusBarScroll {
  static const _channel = MethodChannel('pilinara/ios_statusbar');

  static void init() {
    if (!Platform.isIOS) return;
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'scrollToTop') {
        WidgetsBinding.instance.handlePopRoute();
        await Scrollable.ensureVisible(
          PrimaryScrollController.of(
            WidgetsBinding.instance.rootElement!,
          ).context!,
          duration: const Duration(milliseconds: 450),
          alignment: 0,
        );
      }
    });
  }
}
