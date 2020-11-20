import UIKit

extension UIColor {
  static let redOrange = UIColor.fromRGB(component: (red: 253, green: 77, blue: 42))
  static let brightGrey = UIColor.fromRGB(component: (red: 82, green: 82, blue: 88))
  static let blueWhale = UIColor.fromRGB(component: (red: 22, green: 44, blue: 54))
  static let darkTurquoise = UIColor.fromRGB(component: (red: 0, green: 186, blue: 224))
  static let brightTurquoise = UIColor.fromRGB(component: (red: 0, green: 250, blue: 208))
  static let heather = UIColor.fromRGB(component: (red: 170, green: 180, blue: 190))
  
  static var primaryOne: UIColor {
    return UIColor { trait in
      return trait.userInterfaceStyle == .light ? redOrange : darkTurquoise
    }
  }
  
  static var primaryTwo: UIColor {
    return UIColor { trait in
      return trait.userInterfaceStyle == .light ? white : blueWhale
    }
  }
  
  static var primaryThree: UIColor {
    return UIColor { trait in
      return trait.userInterfaceStyle == .light ? brightGrey : heather
    }
  }
}
