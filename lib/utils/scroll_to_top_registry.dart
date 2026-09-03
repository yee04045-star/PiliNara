import 'package:flutter/widgets.dart';

/// Global registry for iOS style status-bar tap-to-scroll-top behavior.
class ScrollToTopRegistry {
  static final Map<String, ScrollController> _controllers = {};

  static void register(String key, ScrollController controller) {
    _controllers[key]?.removeListener(() {});
    _controllers[key] = controller;
  }

  static void unregister(String key) {
    _controllers.remove(key);
  }

  static Future<void> scrollToTop({String? key}) async {
    final controller = key == null
        ? (_controllers.values.isEmpty ? null : _controllers.values.first)
        : _controllers[key];
    if (controller?.hasClients != true) return;
    await controller!.animateTo(
      0,
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
    );
  }
}
