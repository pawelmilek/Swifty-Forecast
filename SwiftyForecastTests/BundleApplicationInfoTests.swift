import XCTest
@testable import SwiftyForecast

class BundleApplicationInfoTests: XCTestCase {

  func testReleaseVersionNumber_getsLatestReleaseVersion() {
    let expected = "2.0.1"
    XCTAssertEqual(expected, Bundle.main.releaseVersionNumber)
  }

  func testBuildNumber_getsLatestBuildNumber() {
    let expected = "3"
    XCTAssertEqual(expected, Bundle.main.buildNumber)
  }
  
  func testApplicationName_getsApplicationName() {
    let expected = "SwiftyForecast"
    XCTAssertEqual(expected, Bundle.main.applicationName)
  }
  
  func testApplicationReleaseDate_getsApplicationReleaseDate() {
    let expected = "2020-11-18".toDate()
    XCTAssertEqual(expected, Bundle.main.applicationReleaseDate.toDate())
  }
  
  func testApplicationReleaseNumber_getsApplicationReleaseNumber() {
    let expected = 0
    XCTAssertEqual(expected, Bundle.main.applicationReleaseNumber)
  }
}
