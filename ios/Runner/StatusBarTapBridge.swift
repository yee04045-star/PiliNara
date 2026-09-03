import Flutter
import SwiftUI
import UIKit

/// Native iOS 26 Liquid Glass surface exposed to Flutter as a platform view.
final class PiliNativeLiquidGlassFactory: NSObject, FlutterPlatformViewFactory {
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
    return PiliNativeLiquidGlassView(
      frame: frame,
      viewId: viewId,
      messenger: messenger,
      parameters: parameters
    )
  }
}

final class PiliNativeLiquidGlassView: NSObject, FlutterPlatformView {
  private let container: UIView
  private var hostingController: UIViewController?

  init(
    frame: CGRect,
    viewId: Int64,
    messenger: FlutterBinaryMessenger,
    parameters: [String: Any]
  ) {
    container = UIView(frame: frame)
    super.init()

    container.backgroundColor = .clear
    container.isOpaque = false

    let radius = CGFloat((parameters["radius"] as? NSNumber)?.doubleValue ?? 22)
    let interactive = (parameters["interactive"] as? Bool) ?? true

    if #available(iOS 26.0, *) {
      let controller = UIHostingController(
        rootView: PiliLiquidGlassShape(radius: radius, interactive: interactive)
      )
      controller.view.backgroundColor = .clear
      controller.view.isOpaque = false
      controller.view.frame = container.bounds
      controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      container.addSubview(controller.view)
      hostingController = controller
    } else {
      let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
      effectView.frame = container.bounds
      effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      effectView.layer.cornerRadius = radius
      effectView.layer.cornerCurve = .continuous
      effectView.clipsToBounds = true
      container.addSubview(effectView)
    }
  }

  func view() -> UIView {
    container
  }
}

@available(iOS 26.0, *)
private struct PiliLiquidGlassShape: View {
  let radius: CGFloat
  let interactive: Bool

  var body: some View {
    Color.clear
      .glassEffect(
        interactive ? .regular.interactive() : .regular,
        in: RoundedRectangle(cornerRadius: radius, style: .continuous)
      )
  }
}
