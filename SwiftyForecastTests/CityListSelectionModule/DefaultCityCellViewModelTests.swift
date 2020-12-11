import XCTest
import RealmSwift
@testable import SwiftyForecast

// swiftlint:disable force_try
class DefaultCityCellViewModelTests: XCTestCase {
  private var sut: DefaultCityCellViewModel!
  private var mockTimeZoneLoader: MockTimeZoneLoader!
  private var realm: Realm!

  override func setUp() {
    super.setUp()
    mockTimeZoneLoader = MockTimeZoneLoader()
    realm = RealmProvider.core.fakeForTesting.realm
    sut = DefaultCityCellViewModel(city: MockGenerator.generateCupertinoCityDTO(),
                                   timeZoneLoader: mockTimeZoneLoader,
                                   realm: realm)
  }

  override func tearDown() {
    sut = nil
    super.tearDown()
  }

  func testCityCupertinoInUnitedStates() {
    XCTAssertEqual(sut.name, "Cupertino, United States")
  }

  func testCity1000AMLocalTime() {
    XCTAssertEqual(sut.localTime, "10:00AM")
  }

  func testLoadTimeZone_whenCityLocalTimeIsAvailable_getsCityTimeZoneIdentifier() {
    let onLoadExpectation = expectation(description: #function)
    var expectedResult: String!
    mockTimeZoneLoader.onLoadCompletionResult = .success(TimeZone(abbreviation: "CDT")!)

    let result = sut.loadTimeZone { result in
      if case let .success(data) = result {
        expectedResult = data
      }

      onLoadExpectation.fulfill()
    }

    wait(for: [onLoadExpectation], timeout: 2)
    XCTAssertNil(result)
    XCTAssertEqual("America/Los_Angeles", expectedResult)
  }

  func testLoadTimeZone_whenCityLocalTimeIsNotApplicable_loadsTimeZone() {
    givenAddCityWithInvalidLocalTimeIntoDatabase()

    let onLoadExpectation = expectation(description: #function)
    var expectedResult: String!
    mockTimeZoneLoader.onLoadCompletionResult = .success(TimeZone(abbreviation: "CDT")!)

    let result = sut.loadTimeZone { result in
      if case let .success(data) = result {
        expectedResult = data
      }

      onLoadExpectation.fulfill()
    }

    wait(for: [onLoadExpectation], timeout: 5)
    XCTAssertNotNil(result)
    XCTAssertEqual("America/Chicago", expectedResult)
  }

  func testCancelLoad_cancelsLoading() {
    sut.cancelLoad(UUID())
    XCTAssertTrue(mockTimeZoneLoader.onCancelRunningRequests)
  }
}

// MARK: - Private - Given
private extension DefaultCityCellViewModelTests {

  func givenAddCityWithInvalidLocalTimeIntoDatabase() {
    let city = MockGenerator.generateChicagoWithInvalidLocalTimeCityDTO()
    sut = DefaultCityCellViewModel(city: city, timeZoneLoader: mockTimeZoneLoader, realm: realm)

    let cityDataAccessObject = DefaultCityDAO(realm: realm)
    let chicagoCity = ModelTranslator().translate(dto: city)
    try! cityDataAccessObject.put(chicagoCity)
  }
}
