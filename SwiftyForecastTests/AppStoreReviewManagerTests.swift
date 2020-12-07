import XCTest
@testable import SwiftyForecast

class AppStoreReviewManagerTests: XCTestCase {
  private var userDefaults: UserDefaults!
  private var sut: AppStoreReviewManager!

  override func setUp() {
    super.setUp()

    let defaultsName = "AppStoreReviewManagerTests"
    userDefaults = UserDefaults(suiteName: defaultsName)
    userDefaults.removePersistentDomain(forName: defaultsName)
    userDefaults.set(InvalidReference.notApplicable, forKey: AppStoreReviewStorageKey.lastReviewVersion.key)

    sut = AppStoreReviewManager(storage: userDefaults)
  }

  override func tearDown() {
    userDefaults = nil
    sut = nil
    super.tearDown()
  }

  func testRequestReview_addTwoLocations_setsLastReviewAppVersion() {
    sut.requestReview(for: .locationAdded)
    sut.requestReview(for: .locationAdded)

    let expected = Bundle.main.releaseVersionNumber
    let appVersion = userDefaults.string(forKey: AppStoreReviewStorageKey.lastReviewVersion.key)
    XCTAssertEqual(expected, appVersion)
  }

  func testRequestReview_expandDetailsTwice_setsLastReviewAppVersion() {
    sut.requestReview(for: .detailsInteractionExpanded)
    sut.requestReview(for: .detailsInteractionExpanded)

    let expected = Bundle.main.releaseVersionNumber
    let appVersion = userDefaults.string(forKey: AppStoreReviewStorageKey.lastReviewVersion.key)
    XCTAssertEqual(expected, appVersion)
  }

  func testRequestReview_setEnjoyableOutsideTemperatureTo90Fahrenheit_setsLastReviewAppVersion() {
    sut.requestReview(for: .enjoyableOutsideTemperatureReached(value: 90))

    let expected = Bundle.main.releaseVersionNumber
    let appVersion = userDefaults.string(forKey: AppStoreReviewStorageKey.lastReviewVersion.key)
    XCTAssertEqual(expected, appVersion)
  }
}
