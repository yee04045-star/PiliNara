import UIKit
import Flutter

final class PiliStatusBarTapWindow: UIWindow {
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let view = super.hitTest(point, with: event)
    if point.y <= safeAreaInsets.top + 20 {
      NotificationCenter.default.post(
        name: Notification.Name("PiliStatusBarTap"),
        object: nil
      )
    }
    return view
  }
}
