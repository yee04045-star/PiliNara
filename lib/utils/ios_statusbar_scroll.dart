import 'package:PiliPlus/utils/scroll_to_top_registry.dart';
import 'package:flutter/widgets.dart';

/// Uses Flutter's native iOS status-bar-touch message instead of synthesizing
/// touch events in a custom UIWindow.
class IOSStatusBarScroll with WidgetsBindingObserver {
  IOSStatusBarScroll._();

  static final IOSStatusBarScroll _instance = IOSStatusBarScroll._();
  static bool _initialized = false;

  static void init() {
    if (_initialized) return;
    _initialized = true;
    WidgetsBinding.instance.addObserver(_instance);
  }

  @override
  void handleStatusBarTap() {
    super.handleStatusBarTap();
    ScrollToTopRegistry.scrollToTop();
  }
}
