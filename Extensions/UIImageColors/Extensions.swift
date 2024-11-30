import UIKit

extension UIColor {
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return adjust(by: -1 * abs(percentage))
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(
                red: max(min(red + percentage / 100, 1.0), 0.0),
                green: max(min(green + percentage / 100, 1.0), 0.0),
                blue: max(min(blue + percentage / 100, 1.0), 0.0),
                alpha: alpha
            )
        } else {
            return nil
        }
    }
}
