import XCTest
@testable import SwiftyForecast

// swiftlint:disable force_cast
class FontLoaderTests: XCTestCase {

  func testLoadFont_throwsFileNotFoundError() {
    let name = "FontWeather_not_existing"
    XCTAssertThrowsError(try FontLoader.loadFont(with: name, bundle: Bundle(for: type(of: self)))) { error in
      if case let .fileNotFound(fileName) = (error as! FontWeatherIconError) {
        XCTAssertEqual(fileName, fileName)
      }
    }
  }
}
