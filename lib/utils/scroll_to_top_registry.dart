import 'dart:async';

import 'package:flutter/widgets.dart';

/// Tracks the active page's scroll-to-top action for iOS status-bar taps.
class ScrollToTopRegistry {
  static final Map<String, FutureOr<void> Function()> _actions = {};
  static String? _activeKey;

  static void registerCallback(
    String key,
    FutureOr<void> Function() action, {
    bool active = false,
  }) {
    _actions[key] = action;
    if (active || _activeKey == null) {
      _activeKey = key;
    }
  }

  static void register(
    String key,
    ScrollController controller, {
    bool active = false,
  }) {
    registerCallback(
      key,
      () {
        if (!controller.hasClients) return Future<void>.value();
        return controller.animateTo(
          0,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOutCirc,
        );
      },
      active: active,
    );
  }

  static void setActive(String key) {
    if (_actions.containsKey(key)) {
      _activeKey = key;
    }
  }

  static void unregister(String key) {
    _actions.remove(key);
    if (_activeKey == key) {
      _activeKey = _actions.keys.isEmpty ? null : _actions.keys.first;
    }
  }

  static Future<void> scrollToTop({String? key}) async {
    final action = _actions[key ?? _activeKey];
    if (action == null) return;
    await action();
  }
}
