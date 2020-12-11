import XCTest
@testable import SwiftyForecast

class HourlyCellViewModelTests: XCTestCase {
  private var notationController: NotationController!
  private var hourlyForecast: HourlyForecastDTO!
  private var sut: DefaultHourlyCellViewModel!

  override func setUp() {
    super.setUp()
    let defaultsName = "NotationControllerTests"
    let userDefaults = UserDefaults(suiteName: defaultsName)!
    userDefaults.removePersistentDomain(forName: defaultsName)
    notationController = NotationController(storage: userDefaults)

    hourlyForecast = MockGenerator.generateHourlyForecast()
    sut = DefaultHourlyCellViewModel(hourlyData: hourlyForecast.data.first!, notationController: notationController)
  }

  override func tearDown() {
    sut = nil
    super.tearDown()
  }

  func testTime_gets300PM() {
    let expected = "3:00 PM"
    XCTAssertEqual(expected, sut.time)
  }

  func testConditionIcon_getsSleetConditionIcon() {
    let iconSize = Style.HourlyForecastCell.conditionIconSize
    let expected = ConditionFontIcon.make(icon: "sleet", font: iconSize)?.attributedIcon
    XCTAssertEqual(expected, sut.conditionIcon!)
  }

  func testTemperature_getsTemperatureInCelsius() {
    notationController.temperatureNotation = .celsius
    let expected = "1°"
    XCTAssertEqual(expected, sut.temperature)
  }

  func testTemperature_getsTemperatureInFahrenheit() {
    notationController.temperatureNotation = .fahrenheit
    let expected = "34°"
    XCTAssertEqual(expected, sut.temperature)
  }

  func testHourlyForecastIcon() {
    let newIcon = hourlyForecast.icon
    XCTAssertEqual(newIcon, "sleet", "Hourly forecast icon is incorrect.")
  }

  func testHourlyForecastSummary() {
    let summary = hourlyForecast.summary
    XCTAssertEqual(summary, "Mixed precipitation throughout the day.", "Hourly forecast summary is incorrect.")
  }

  func testHourlyForecastNumberOfHours() {
    let hours = hourlyForecast.data.count
    let expectedValue = 24
    XCTAssertEqual(hours, expectedValue, "Forecast's number of hourly is incorrect.")
  }

  func testHourlyForecastCellTimeAndConditionIcon() {
    let expectedValue = ConditionFontIcon.make(icon: "sleet", font: 25)!.attributedIcon
    XCTAssertEqual(sut.time, "3:00 PM")
    XCTAssertEqual(sut.conditionIcon!, expectedValue)
  }
}
