import XCTest
@testable import SwiftyForecast

class DoubleToTemperatureTests: XCTestCase {

  func testTenFahrenheitToCelsius() {
    XCTAssertEqual(10.0.toCelsius(), -12.222222222220125)
  }

  func testTwentyTwoAndHalfFahrenheitToCelsius() {
    XCTAssertEqual(22.5.toCelsius(), -5.277777777775611)
  }

  func testEightyEightFahrenheitToCelsius() {
    XCTAssertEqual(88.0.toCelsius(), 31.111111111113587)
  }

  func testTenCelsiusToFahrenheit() {
    XCTAssertEqual(10.0.toFahrenheit(), 49.99999999999585)
  }

  func testTwentyTwoAndHalfCelsiusToFahrenheit() {
    XCTAssertEqual(22.5.toFahrenheit(), 72.49999999999567)
  }

  func testEightyEightCelsiusToFahrenheit() {
    XCTAssertEqual(88.0.toFahrenheit(), 190.39999999999472)
  }
}
