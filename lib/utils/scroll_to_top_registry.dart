import 'package:flutter/widgets.dart';

class ScrollToTopRegistry {
  static final Map<String, ScrollController> _controllers = {};

  static void register(String id, ScrollController controller) {
    _controllers[id] = controller;
  }

  static void unregister(String id) {
    _controllers.remove(id);
  }

  static Future<void> scrollAllToTop() async {
    for (final controller in _controllers.values) {
      if (!controller.hasClients) continue;
      await controller.animateTo(
        0,
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
      );
    }
  }
}
