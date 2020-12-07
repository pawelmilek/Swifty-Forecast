import XCTest
@testable import SwiftyForecast

class ColorFromRGBTests: XCTestCase {
  func testRedColor_returnsRed() {
    let expected = UIColor.red
    let redOrange = UIColor.fromRGB(component: (red: 255, green: 0, blue: 0))
    XCTAssertEqual(expected, redOrange)
  }
}
