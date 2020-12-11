import UIKit

struct ConditionFontIcon {
  enum ConditionType: String {
    case clearDay = "clear-day"
    case clearNight = "clear-night"
    case cloudy = "cloudy"
    case partlyCloudyDay = "partly-cloudy-day"
    case partlyCloudyNight = "partly-cloudy-night"
    case fog = "fog"
    case rain = "rain"
    case snow = "snow"
    case sleet = "sleet"
    case wind = "wind"
    case hail = "hail"
    case thunderstorm = "thunderstorm"
    case tornado = "tornado"
  }

  let attributedIcon: NSAttributedString

  init(attributedIcon: NSAttributedString) {
    self.attributedIcon = attributedIcon
  }
}

// MARK: - WeatherFontIcon protocol
extension ConditionFontIcon {

  static func make(icon: String, font size: CGFloat) -> ConditionFontIcon? {
    guard let condition = ConditionType(rawValue: icon) else { return nil }

    var attributedFont: NSAttributedString {
      switch condition {
      case .clearDay:
        return FontWeatherIconType.daySunny.attributedString(font: size)

      case .clearNight:
        return FontWeatherIconType.nightClear.attributedString(font: size)

      case .cloudy:
        return FontWeatherIconType.dayCloudy.attributedString(font: size)

      case .partlyCloudyDay:
        return FontWeatherIconType.dayCloudy.attributedString(font: size)

      case .partlyCloudyNight:
        return FontWeatherIconType.nightCloudy.attributedString(font: size)

      case .fog:
        return FontWeatherIconType.fog.attributedString(font: size)

      case .rain:
        return FontWeatherIconType.rain.attributedString(font: size)

      case .snow:
        return FontWeatherIconType.snow.attributedString(font: size)

      case .sleet:
        return FontWeatherIconType.sleet.attributedString(font: size)

      case .wind:
        return FontWeatherIconType.windy.attributedString(font: size)

      case .hail:
        return FontWeatherIconType.hail.attributedString(font: size)

      case .thunderstorm:
        return FontWeatherIconType.thunderstorm.attributedString(font: size)

      case .tornado:
        return FontWeatherIconType.tornado.attributedString(font: size)
      }
    }

    return ConditionFontIcon(attributedIcon: attributedFont)
  }

}
