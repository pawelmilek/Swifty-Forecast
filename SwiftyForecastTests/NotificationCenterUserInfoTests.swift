import XCTest
@testable import SwiftyForecast

class NotificationCenterUserInfoTests: XCTestCase {

  func testUserInfoKey_returnsKeys() {
    XCTAssertEqual("segmentedControlChanged", NotificationCenterUserInfo.segmentedControlChanged.key)
    XCTAssertEqual("cityUpdatedAtIndex", NotificationCenterUserInfo.cityUpdatedAtIndex.key)
    XCTAssertEqual("cityUpdated", NotificationCenterUserInfo.cityUpdated.key)
    XCTAssertEqual("cityAdded", NotificationCenterUserInfo.cityAdded.key)
  }

}
