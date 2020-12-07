import XCTest
@testable import SwiftyForecast

class ColorFromHexTests: XCTestCase {

  func testRedColor_when3Value_returnsYellow() {
    let expected = UIColor(red: 1, green: 1, blue: 0, alpha: 1)
    let yellow = UIColor.fromHex(hex: "#ff0")
    XCTAssertEqual(expected, yellow)
  }

  func testRedColor_when6Value_returnsRed() {
    let expected = UIColor.red
    let red = UIColor.fromHex(hex: "#ff0000")
    XCTAssertEqual(expected, red)
  }

  func testRedColor_when8Value_returnsDarkBlue() {
    let expected = UIColor(red: 0, green: 0, blue: 0.6, alpha: 1)
    let darkBlue = UIColor.fromHex(hex: "#ff000099")
    XCTAssertEqual(expected, darkBlue)
  }

  func testRedColor_whenIncorrectFormat_returnsBlack() {
    let expected = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    let black = UIColor.fromHex(hex: "#f")
    XCTAssertEqual(expected, black)
  }

}
