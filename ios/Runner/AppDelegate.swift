import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    application.applicationSupportsShakeToEdit = false // Disable shake to undo

    if #available(iOS 26.0, *) {
      // Keep native UIKit surfaces on the system-managed Liquid Glass path.
      // Flutter-rendered widgets use the shared LiquidGlass theme utility.
      let navigationAppearance = UINavigationBarAppearance()
      navigationAppearance.configureWithDefaultBackground()
      UINavigationBar.appearance().standardAppearance = navigationAppearance
      UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance

      let tabAppearance = UITabBarAppearance()
      tabAppearance.configureWithDefaultBackground()
      UITabBar.appearance().standardAppearance = tabAppearance
      UITabBar.appearance().scrollEdgeAppearance = tabAppearance
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    guard let registrar = engineBridge.pluginRegistry.registrar(
      forPlugin: "PiliNativeGlassNavigation"
    ) else {
      return
    }
    registrar.register(
      PiliNativeGlassNavigationFactory(messenger: registrar.messenger()),
      withId: "piliplus/liquid_glass_navigation"
    )
  }
}


final class PiliNativeGlassNavigationFactory: NSObject, FlutterPlatformViewFactory {
  private let messenger: FlutterBinaryMessenger

  init(messenger: FlutterBinaryMessenger) {
    self.messenger = messenger
    super.init()
  }

  func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    FlutterStandardMessageCodec.sharedInstance()
  }

  func create(
    withFrame frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> FlutterPlatformView {
    let parameters = args as? [String: Any] ?? [:]
    return PiliNativeGlassNavigationView(
      frame: frame,
      viewId: viewId,
      messenger: messenger,
      parameters: parameters
    )
  }
}

final class PiliNativeGlassNavigationView: NSObject, FlutterPlatformView, UITabBarDelegate {
  private let container: UIView
  private let tabBar: UITabBar
  private let channel: FlutterMethodChannel

  init(
    frame: CGRect,
    viewId: Int64,
    messenger: FlutterBinaryMessenger,
    parameters: [String: Any]
  ) {
    container = UIView(frame: frame)
    tabBar = UITabBar(frame: .zero)
    channel = FlutterMethodChannel(
      name: "piliplus/liquid_glass_navigation/\(viewId)",
      binaryMessenger: messenger
    )
    super.init()

    container.backgroundColor = .clear
    tabBar.delegate = self
    tabBar.translatesAutoresizingMaskIntoConstraints = false
    tabBar.isTranslucent = true
    container.addSubview(tabBar)
    NSLayoutConstraint.activate([
      tabBar.leadingAnchor.constraint(equalTo: container.leadingAnchor),
      tabBar.trailingAnchor.constraint(equalTo: container.trailingAnchor),
      tabBar.topAnchor.constraint(equalTo: container.topAnchor),
      tabBar.bottomAnchor.constraint(equalTo: container.bottomAnchor),
    ])

    let labels = parameters["labels"] as? [String] ?? []
    let symbols = parameters["symbols"] as? [String] ?? []
    let selectedIndex = parameters["selectedIndex"] as? Int ?? 0
    tabBar.items = labels.enumerated().map { index, label in
      let image = index < symbols.count ? UIImage(systemName: symbols[index]) : nil
      let item = UITabBarItem(title: label, image: image, tag: index)
      item.accessibilityIdentifier = "PiliPlus.tab.\(index)"
      return item
    }
    if let item = tabBar.items?.dropFirst(selectedIndex).first {
      tabBar.selectedItem = item
    }

    channel.setMethodCallHandler { [weak self] call, result in
      guard let self else { return }
      switch call.method {
      case "update":
        update(parameters: call.arguments as? [String: Any] ?? [:])
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    if #available(iOS 26.0, *) {
      let appearance = UITabBarAppearance()
      appearance.configureWithDefaultBackground()
      tabBar.standardAppearance = appearance
      tabBar.scrollEdgeAppearance = appearance
    } else {
      tabBar.backgroundImage = UIImage()
      tabBar.shadowImage = UIImage()
      tabBar.standardAppearance = UITabBarAppearance()
    }
  }

  private func update(parameters: [String: Any]) {
    let labels = parameters["labels"] as? [String] ?? []
    let symbols = parameters["symbols"] as? [String] ?? []
    tabBar.items = labels.enumerated().map { index, label in
      let image = index < symbols.count ? UIImage(systemName: symbols[index]) : nil
      return UITabBarItem(title: label, image: image, tag: index)
    }
    if let index = parameters["selectedIndex"] as? Int,
       let item = tabBar.items?.first(where: { $0.tag == index }) {
      tabBar.selectedItem = item
    }
  }

  func view() -> UIView { container }

  func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    channel.invokeMethod("selected", arguments: item.tag)
  }
}
