import UIKit

extension UIApplication {
    func boltStrikeTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return boltStrikeTopViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return boltStrikeTopViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return boltStrikeTopViewController(base: presented)
        }
        return base
    }
}
