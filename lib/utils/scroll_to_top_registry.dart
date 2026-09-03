import 'package:flutter/widgets.dart';

/// Global registry for iOS status-bar tap -> scroll to top.
class ScrollToTopRegistry {
  static final Map<String, ScrollController> _controllers = {};

  static void register(String key, ScrollController controller) {
    _controllers[key] = controller;
  }

  static void unregister(String key) {
    _controllers.remove(key);
  }

  static void scrollToTop() {
    for (final controller in _controllers.values) {
      if (!controller.hasClients) continue;
      controller.animateTo(
        0,
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
      );
    }
  }
}
