import SwiftUI
import UIKit
import Flutter

private struct NativeLiquidGlassContent: View {
    let radius: CGFloat
    let interactive: Bool

    var body: some View {
        Color.clear
            .glassEffect(
                .regular.interactive(interactive),
                in: .rect(cornerRadius: radius)
            )
            .ignoresSafeArea()
    }
}

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
        let radius = CGFloat((parameters["radius"] as? Double) ?? 22)
        let interactive = (parameters["interactive"] as? Bool) ?? true
        return PiliNativeLiquidGlassView(
            frame: frame,
            radius: radius,
            interactive: interactive
        )
    }
}

final class PiliNativeLiquidGlassView: NSObject, FlutterPlatformView {
    private let container: UIView
    private var hostingController: UIHostingController<NativeLiquidGlassContent>?

    init(frame: CGRect, radius: CGFloat, interactive: Bool) {
        container = UIView(frame: frame)
        super.init()

        container.backgroundColor = .clear
        container.isOpaque = false

        guard #available(iOS 26.0, *) else { return }

        let rootView = NativeLiquidGlassContent(
            radius: max(0, radius),
            interactive: interactive
        )
        let controller = UIHostingController(rootView: rootView)
        controller.view.backgroundColor = .clear
        controller.view.isOpaque = false
        controller.view.frame = container.bounds
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostingController = controller
        container.addSubview(controller.view)
    }

    func view() -> UIView { container }
}
