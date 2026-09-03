import UIKit

final class StatusBarTapBridgeWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if point.y < 60 {
            NotificationCenter.default.post(name: NSNotification.Name("PiliStatusBarTap"), object: nil)
        }
        return super.hitTest(point, with: event)
    }
}
