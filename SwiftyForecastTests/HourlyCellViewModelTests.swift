import XCTest
@testable import SwiftyForecast

class HourlyCellViewModelTests: XCTestCase {
  private var notationController: NotationController!
  private var sut: DefaultHourlyCellViewModel!

  override func setUp() {
    super.setUp()
    let defaultsName = "NotationControllerTests"
    let userDefaults = UserDefaults(suiteName: defaultsName)!
    userDefaults.removePersistentDomain(forName: defaultsName)
    notationController = NotationController(storage: userDefaults)

    let hourlyData = MockGenerator.generateHourlyForecast().data.first!
    sut = DefaultHourlyCellViewModel(hourlyData: hourlyData, notationController: notationController)
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
}
