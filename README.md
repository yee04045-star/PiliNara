Stage 5 Liquid Glass patch

Modified:
- Added ScrollToTopRegistry
- Added iOS status bar tap bridge
- Added LiquidGlassHud
- Added GlassSheet

Integration points:
home feed controllers register ScrollController.
AppDelegate installs Notification -> Flutter MethodChannel bridge.
Video controls wrap with LiquidGlassHud.
Reply sheets wrap with GlassSheet.
