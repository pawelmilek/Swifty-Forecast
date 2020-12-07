import Foundation

struct DefaultHourlyCellViewModel: HourlyCellViewModel {
  let time: String
  let conditionIcon: NSAttributedString?
  private let notationController: NotationController
  private var hourlyData: HourlyDataDTO

  init(hourlyData: HourlyDataDTO, notationController: NotationController = NotationController()) {
    self.hourlyData = hourlyData
    self.notationController = notationController
    self.time = hourlyData.date.getTime()

    let iconSize = Style.HourlyForecastCell.conditionIconSize
    self.conditionIcon = ConditionFontIcon.make(icon: hourlyData.icon, font: iconSize)?.attributedIcon
  }
}

// MARK: - Temperature in Celsius
extension DefaultHourlyCellViewModel {

  var temperature: String {

    switch notationController.temperatureNotation {
    case .celsius:
      let temperatureInCelsius = hourlyData.temperature.toCelsius()
      return temperatureInCelsius.roundedToString + Style.degreeSign

    case .fahrenheit:
      return hourlyData.temperature.roundedToString + Style.degreeSign
    }
  }

}
