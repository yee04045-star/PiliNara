import 'package:flutter/widgets.dart';

class ScrollToTopRegistry {
  static final Map<String, ScrollController> _controllers = {};

  static void register(String id, ScrollController controller) {
    _controllers[id] = controller;
  }

  static void unregister(String id) {
    _controllers.remove(id);
  }

  static void scrollAllToTop() {
    for (final controller in _controllers.values) {
      if (controller.hasClients) {
        controller.animateTo(
          0,
          duration: const Duration(milliseconds: 380),
          curve: Curves.easeOutCubic,
        );
      }
    }
  }
}
