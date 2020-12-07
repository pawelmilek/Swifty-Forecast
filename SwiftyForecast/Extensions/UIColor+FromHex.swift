import UIKit

extension UIColor {

  class func fromHex(hex: String) -> UIColor? {
    let trimmedHexString = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int = UInt64()
    Scanner(string: trimmedHexString).scanHexInt64(&int)
    let alpha, red, green, blue: UInt64

    switch trimmedHexString.count {
    case 3:
      (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)

    case 6:
      (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)

    case 8:
      (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)

    default:
      (alpha, red, green, blue) = (255, 0, 0, 0)
    }

    let redValue = CGFloat(red) / 255
    let greenValue = CGFloat(green) / 255
    let blueValue = CGFloat(blue) / 255
    let alphaValue = CGFloat(alpha) / 255
    return self.init(red: redValue, green: greenValue, blue: blueValue, alpha: alphaValue)
  }

}
