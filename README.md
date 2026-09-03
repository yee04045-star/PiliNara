PiliNara Liquid Glass Stage4 patch

Implemented:
- Global ScrollController registry for system status bar tap to top.
- LiquidGlassHud for video player overlay.
- GlassSheet for iOS 26 style modal sheets.
- UIKit status bar tap bridge placeholder.

Integration points:
1. Home controller register its Feed ScrollController.
2. AppDelegate forwards PiliStatusBarTap to Flutter MethodChannel.
3. Replace video controls container with LiquidGlassHud.
4. Wrap showModalBottomSheet builders with GlassSheet.
