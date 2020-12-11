import XCTest
@testable import SwiftyForecast

// swiftlint:disable force_try
class DefaultForecastDAOTests: XCTestCase {
  private var sut: DefaultForecastDAO!
  private let stubForecast = MockGenerator.generateForecast()!

  override func setUp() {
    super.setUp()

    let realm = RealmProvider.core.fakeForTesting.realm
    sut = DefaultForecastDAO(realm: realm)
  }

  override func tearDown() {
    super.tearDown()
    sut = nil
  }

  func testPutForecast_addIntoRealm() {
    givenAddForecastResponseIntoDatabase()
    XCTAssertNotNil(sut.get(latitude: 41.8781136, longitude: -87.6297982))
  }

  func testDelete_removesData() {
    givenAddForecastResponseIntoDatabase()
    try! sut.delete(stubForecast)
    XCTAssertNil(sut.get(latitude: 41.8781136, longitude: -87.6297982))
  }

  func testDeleteAll_removesData() {
    givenAddForecastResponseIntoDatabase()
    try! sut.deleteAll()
    XCTAssertNil(sut.get(latitude: 41.8781136, longitude: -87.6297982))
  }
}

// MARK: - Private - Given
private extension DefaultForecastDAOTests {

  func givenAddForecastResponseIntoDatabase() {
    sut.put(stubForecast)
  }
}
