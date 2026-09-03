# iOS 26 Liquid Glass support

This patch adds an iOS 26-aware visual treatment to PiliPlus while preserving the existing appearance on Android, desktop platforms, and older iOS versions.

## What changed

`lib/utils/liquid_glass.dart` provides runtime detection for iOS 26 or newer and a restrained translucent Flutter surface using `BackdropFilter`. It intentionally applies the effect only to important custom surfaces rather than wrapping the entire application.

`lib/utils/theme_utils.dart` applies the iOS 26 palette to shared app bars, Material navigation bars, dialogs, and bottom sheets. These are Flutter approximations of the Liquid Glass visual language; Flutter-rendered widgets do not automatically become native Apple Liquid Glass components.

`ios/Runner/AppDelegate.swift` keeps native UIKit navigation and tab bars on the system-managed appearance path when the app is running on iOS 26 or newer. The availability check means the source remains buildable for the existing older deployment target.

`.github/workflows/ios-liquid-glass.yml` builds an unsigned iOS artifact on `macos-26`, using the Flutter version declared in `pubspec.yaml`. It first asks Flutter to generate the iOS configuration, then invokes `xcodebuild` with `CODE_SIGNING_ALLOWED=NO` and `CODE_SIGNING_REQUIRED=NO`. The artifact must be codesigned before installation on a physical device.

## GitHub build

Commit or upload these changed files, then open **Actions → Build iOS 26 Liquid Glass variant → Run workflow**. The workflow produces an artifact named `PiliPlus-iOS-26-liquid-glass`. It runs the repository’s existing `lib/scripts/build.ps1` release script first; that script generates `pili_release.json` and the version environment value automatically. It then runs `lib/scripts/patch.ps1 iOS`, which is required by this repository to patch the Flutter SDK APIs used by PiliPlus. The patched script first runs `git apply --check`. The repository-specific iOS patches remain strict, while version-sensitive Flutter framework, `material_ui`, and `cupertino_ui` compatibility patches are skipped with warnings when they no longer match the selected SDK; this prevents upstream Flutter changes from blocking the build. The workflow uses Flutter’s `--config-only` mode and performs the unsigned device compilation directly through Xcode, avoiding Flutter’s final Development Team validation.

For App Store or TestFlight distribution, replace the unsigned packaging step with the project’s normal certificate and provisioning-profile flow. Do not commit signing certificates, provisioning profiles, or release credentials to the repository.

## Hybrid native surfaces

The current hybrid implementation keeps Flutter responsible for pages, networking, media, persistence, and feature logic. On iOS 26, the main bottom navigation is embedded as a native `UITabBar` platform view so UIKit can provide the system-managed Liquid Glass appearance. Flutter sends labels, SF Symbols, selection state, and selection callbacks through a method channel. Android, desktop, older iOS versions, and non-iOS builds continue using the existing Flutter navigation widgets.

This pattern can be extended to additional high-visibility surfaces such as native navigation controllers, toolbars, menus, and presentation hosts. It should not be applied indiscriminately: Apple recommends limiting custom Liquid Glass effects and allowing standard system components to manage their own material and accessibility behavior.

## Limitations

This patch does not rewrite every Flutter widget into Apple-native controls and cannot reproduce private system animations or the full Icon Composer layer model. For the most native result, progressively replace high-priority Flutter navigation surfaces with platform-adaptive widgets and test on physical iOS 26 devices with increased contrast, reduced transparency, dark mode, and reduced motion enabled.
