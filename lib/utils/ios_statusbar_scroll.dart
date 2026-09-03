import 'package:flutter/services.dart';

class IOSStatusBarScroll {
  static final channel = MethodChannel('piliplus/statusbar');
  static VoidCallback? onTap;

  static void init() {
    channel.setMethodCallHandler((call) async {
      if (call.method == 'scrollToTop') {
        onTap?.call();
      }
    });
  }
}
