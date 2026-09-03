# Changes

- Added lib/utils/ios_statusbar_scroll.dart as the Flutter bridge point for iOS status bar scroll-to-top events.
- Initialized bridge in lib/main.dart.
- Existing Liquid Glass support retained.

Note: native status-bar tap delivery requires a UIKit window event monitor; this file provides the Flutter side only.
