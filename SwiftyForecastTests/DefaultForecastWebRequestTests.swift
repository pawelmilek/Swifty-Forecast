import XCTest
@testable import SwiftyForecast

class DefaultForecastWebRequestTests: XCTestCase {
  private var sut: DefaultForecastWebRequest!

  override func setUp() {
    super.setUp()
    sut = DefaultForecastWebRequest()
    sut.latitude = 12.999
    sut.longitude = -12.999
  }

  override func tearDown() {
    super.tearDown()
    sut = nil
  }

  func testbaseURL() {
    let expected = "https://api.forecast.io"
    XCTAssertEqual(sut.baseURL.absoluteString, expected)
  }

  func testPathWithDarkSkyAPIKey() {
    let expected = "forecast/6a92402c27dfc4740168ec5c0673a760/12.999,-12.999"
    XCTAssertEqual(sut.path, expected)
  }

  func testRequestAbsoluteURL() {
    let expected = URL(string: "https://api.forecast.io/forecast/6a92402c27dfc4740168ec5c0673a760/12.999,-12.999")!
    XCTAssertEqual(sut.urlRequest.url!.absoluteURL, expected)
  }

  func testParametersWithUnitsAsUSExcludeMinutelyAlertsFlags() {
    let expected = ["units": "us", "exclude": "minutely,alerts,flags"]
    XCTAssertEqual(sut.parameters, expected)
  }
}
