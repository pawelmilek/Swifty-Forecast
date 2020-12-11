import XCTest
import MapKit
@testable import RealmSwift
@testable import SwiftyForecast

// swiftlint:disable force_try
class DefaultCityListViewModelTests: XCTestCase {
  private var realm: Realm!
  private var cityDAO: DefaultCityDAO!
  private var sut: CityListViewModel!

  override func setUp() {
    super.setUp()

    let cityDTO = MockGenerator.generateCupertinoCityDTO()
    let city = ModelTranslator().translate(dto: cityDTO)

    realm = RealmProvider.core.fakeForTesting.realm
    cityDAO = DefaultCityDAO(realm: realm)
    try! cityDAO.put(city)

    let forecastDAO = DefaultForecastDAO(realm: realm)
    sut = DefaultCityListViewModel(cityDAO: cityDAO, forecastDAO: forecastDAO)
  }

  override func tearDown() {
    realm = nil
    sut = nil
    super.tearDown()
  }

  func testNumberOfCities_returnsOne() {
    XCTAssertEqual(1, sut.numberOfCities)
  }

  func testName_fromFirstIndex_getsCupertinoInUnitedStates() {
    XCTAssertEqual("Cupertino, United States", sut.name(at: 0))
  }

  func testLocalTime_fromFirstIndex_getsCurrentLocalTime() {
    let notExpected = InvalidReference.notApplicable
    XCTAssertNotEqual(notExpected, sut.localTime(at: 0))
  }

  func testMap_fromFirstIndex_getsCupertinoAnnotation() {
    var expected: (annotation: MKPointAnnotation, region: MKCoordinateRegion) {
      let city = cityDAO.getAllOrderedByIndex().first!
      let mkPlacemark = MKPlacemark(placemark: city.placemark!)
      let annotation = MKPointAnnotation()
      annotation.coordinate = mkPlacemark.coordinate
      annotation.title = mkPlacemark.name
      if let city = mkPlacemark.locality, let state = mkPlacemark.administrativeArea {
        annotation.subtitle = "\(city) \(state)"
      }

      let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
      let region = MKCoordinateRegion(center: mkPlacemark.coordinate, span: span)
      return (annotation: annotation, region: region)
    }

    let miniMap = sut.map(at: 0)!
    let miniMapCoordinate = miniMap.annotation.coordinate
    let miniMapSpan = miniMap.region.span

    XCTAssertEqual(expected.annotation.coordinate.latitude, miniMapCoordinate.latitude)
    XCTAssertEqual(expected.annotation.coordinate.longitude, miniMapCoordinate.longitude)
    XCTAssertEqual(expected.region.span.latitudeDelta, miniMapSpan.latitudeDelta)
    XCTAssertEqual(expected.region.span.longitudeDelta, miniMapSpan.longitudeDelta)
  }

  func testCityCellViewModel_fromFirstIndex_getsViewModel() {
    let cellViewModel = sut.cityCellViewModel(at: 0)!
    XCTAssertEqual("Cupertino, United States", cellViewModel.name)
    XCTAssertNotEqual(InvalidReference.notApplicable, cellViewModel.localTime)
    XCTAssertNotNil(cellViewModel.miniMapData)
  }

  func testSelect_selectsFirstCity() {
    var isSelectedFirstCity = false

    sut.onCitySelected = { index in
      isSelectedFirstCity = (index == 0)
    }

    sut.select(at: 0)
    XCTAssertTrue(isSelectedFirstCity)
  }

  func testDelete_atFirstIndex_deletesFirstCity() {
    let expected = 0
    sut.delete(at: IndexPath(row: 0, section: 0))

    XCTAssertEqual(expected, sut.numberOfCities)
  }
}
