import UIKit

// swiftlint:disable large_tuple
extension UIColor {

  class func fromRGB(component: (red: CGFloat, green: CGFloat, blue: CGFloat)) -> UIColor {
    return UIColor(red: component.0/255, green: component.1/255, blue: component.2/255, alpha: 1)
  }

}
