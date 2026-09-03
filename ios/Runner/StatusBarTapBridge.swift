import UIKit
import Flutter

final class StatusBarTapBridgeWindow: UIWindow {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if point.y <= 60 {
            NotificationCenter.default.post(name: .piliStatusBarTap, object: nil)
        }
        return super.point(inside: point, with: event)
    }
}

extension Notification.Name {
    static let piliStatusBarTap = Notification.Name("piliStatusBarTap")
}
