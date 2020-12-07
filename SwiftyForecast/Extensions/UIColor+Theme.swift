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

  // TODO: - Replace with primaryOne, primaryTwo, primaryThree!
  static var primary: UIColor {
    return UIColor { trait in
      return trait.userInterfaceStyle == .light ? UIColor.fromHex(hex: "#fd4d2a")! : darkTurquoise
    }
  }

  static var primaryLight: UIColor {
    return UIColor { trait in
      return trait.userInterfaceStyle == .light ? UIColor.fromHex(hex: "#ff8257")! : darkTurquoise
    }
  }

  static var primaryDark: UIColor {
    return UIColor { trait in
      return trait.userInterfaceStyle == .light ? UIColor.fromHex(hex: "#c20200")! : darkTurquoise
    }
  }

  static var secondary: UIColor {
    return UIColor { trait in
      return trait.userInterfaceStyle == .light ? white : blueWhale
    }
  }

  static var secondaryLight: UIColor {
    return UIColor { trait in
      return trait.userInterfaceStyle == .light ? white : blueWhale
    }
  }

  static var secondaryDark: UIColor {
    return UIColor { trait in
      return trait.userInterfaceStyle == .light ? UIColor.fromHex(hex: "#cccccc")! : blueWhale
    }
  }

  static var onPrimary: UIColor {
    return UIColor { trait in
      return trait.userInterfaceStyle == .light ? .black : .white
    }
  }

  static var onSecondary: UIColor {
    return UIColor { trait in
      return trait.userInterfaceStyle == .light ? .black : heather
    }
  }
}
