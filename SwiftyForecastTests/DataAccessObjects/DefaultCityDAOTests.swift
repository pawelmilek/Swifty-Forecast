import XCTest
@testable import SwiftyForecast

// swiftlint:disable force_try
class DefaultCityDAOTests: XCTestCase {
  private var sut: DefaultCityDAO!

  override func setUp() {
    super.setUp()

    let realm = RealmProvider.core.fakeForTesting.realm
    sut = DefaultCityDAO(realm: realm)
  }

  override func tearDown() {
    super.tearDown()
    sut = nil
  }

  func testGetAllResultOrderedByIndex_returnsTwo() {
    givenAddCityIntoDatabase()
    givenAddCityIntoDatabase()

    XCTAssertEqual(2, sut.getAllResultOrderedByIndex()!.count)
  }

  func testGetAllOrderedByIndex_returnsThree() {
    givenAddCityIntoDatabase()
    givenAddCityIntoDatabase()
    givenAddCityIntoDatabase()

    XCTAssertEqual(3, sut.getAllOrderedByIndex().count)
  }

  func testPut_whenSortIndexPassed_addsCity() {
    let cupertinoCity = ModelTranslator().translate(dto: MockGenerator.generateCupertinoCityDTO())
    let sanFranciscoCity = ModelTranslator().translate(dto: MockGenerator.generateSanFranciscoCityDTO())
    try! sut.put(cupertinoCity, sortIndex: 1)
    try! sut.put(sanFranciscoCity, sortIndex: 2)

    let firstCity = sut.getAllOrderedByIndex().first!
    let secondCity = sut.getAllOrderedByIndex().last!
    XCTAssertEqual(1, firstCity.orderIndex)
    XCTAssertEqual(2, secondCity.orderIndex)
  }

  func testPut_addsCity() {
    givenAddCityIntoDatabase()
    XCTAssertEqual(1, sut.getAllOrderedByIndex().count)
  }

  func testDelete_returnsZero() {
    let cupertinoCity = ModelTranslator().translate(dto: MockGenerator.generateCupertinoCityDTO())

    try! sut.put(cupertinoCity, sortIndex: 1)
    XCTAssertEqual(1, sut.getAllOrderedByIndex().count)

    try! sut.delete(cupertinoCity)
    XCTAssertEqual(0, sut.getAllOrderedByIndex().count)
  }

  func testDeleteAll_getsZero() {
    givenAddCityIntoDatabase()
    givenAddCityIntoDatabase()
    givenAddCityIntoDatabase()
    givenAddCityIntoDatabase()
    XCTAssertEqual(4, sut.getAllOrderedByIndex().count)

    try! sut.deleteAll()
    XCTAssertEqual(0, sut.getAllOrderedByIndex().count)
  }
}

// MARK: - Private - Given
private extension DefaultCityDAOTests {

  func givenAddCityIntoDatabase() {
    let cupertinoCity = ModelTranslator().translate(dto: MockGenerator.generateCupertinoCityDTO())
    try! sut.put(cupertinoCity)
  }

}
