import XCTest
import MapKit
@testable import RealmSwift
@testable import SwiftyForecast

class CityListViewModelTests: XCTestCase {
  private var realm: Realm!
  private var city: City!
  private var sut: CityListViewModel!

  override func setUp() {
    super.setUp()
    realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TemporaryRealm"))


    let cityDTO = MockGenerator.generateCityDTO()
    city = ModelTranslator().translate(dto: cityDTO, in: realm)

    let cityDAO = TestCityDAO()
    try! cityDAO.put(city)

    let forecastDAO = TestForecastDAO()
    sut = DefaultCityListViewModel(cityDAO: cityDAO, forecastDAO: forecastDAO)
  }

  override func tearDown() {
    realm = nil
    city = nil
    sut = nil
    super.tearDown()
  }


  func testNumberOfCities_returnsOneCity() {
    let expected = 1
    XCTAssertEqual(expected, 1)
//    XCTAssertEqual(expected, sut.numberOfCities)
  }
//
//  func testName_fromFirstIndex_getsCupertinoInUnitedStates() {
//    let expected = "Cupertino, United States"
//    XCTAssertEqual(expected, sut.name(at: 0))
//  }
//
//  func testLocalTime_fromFirstIndex_gets532PM() {
//    let notExpected = InvalidReference.notApplicable
//    XCTAssertNotEqual(notExpected, sut.localTime(at: 0))
//  }
//
//  func testMap_fromFirstIndex_getsCupertinoAnnotation() {
//    var expected: (annotation: MKPointAnnotation, region: MKCoordinateRegion) {
//      let mkPlacemark = MKPlacemark(placemark: city.placemark!)
//      let annotation = MKPointAnnotation()
//      annotation.coordinate = mkPlacemark.coordinate
//      annotation.title = mkPlacemark.name
//      if let city = mkPlacemark.locality, let state = mkPlacemark.administrativeArea {
//        annotation.subtitle = "\(city) \(state)"
//      }
//
//      let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//      let region = MKCoordinateRegion(center: mkPlacemark.coordinate, span: span)
//      return (annotation: annotation, region: region)
//    }
//
//    let miniMap = sut.map(at: 0)!
//    let miniMapCoordinate = miniMap.annotation.coordinate
//    let miniMapSpan = miniMap.region.span
//
//    XCTAssertEqual(expected.annotation.coordinate.latitude, miniMapCoordinate.latitude)
//    XCTAssertEqual(expected.annotation.coordinate.longitude, miniMapCoordinate.longitude)
//
//    XCTAssertEqual(expected.region.span.latitudeDelta, miniMapSpan.latitudeDelta)
//    XCTAssertEqual(expected.region.span.longitudeDelta, miniMapSpan.longitudeDelta)
//  }
//
//  func testCityCellName_fromFirstIndex_getsCupertinoInUnitedtates() {
//    let expected = "Cupertino, United States"
//    XCTAssertEqual(expected, sut.name(at: 0))
//  }
//
//  func testCityCellViewModel_fromFirstIndex_getsFirstCity() {
//    XCTAssertNotNil(sut.cityCellViewModel(at: 0))
//  }
//
//  func testSelect_selectsFirstCity() {
//    var isSelectedFirstCity = false
//
//    sut.onCitySelected = { index in
//      isSelectedFirstCity = (index == 0)
//    }
//
//    sut.select(at: 0)
//    XCTAssertTrue(isSelectedFirstCity)
//  }
//
//  func testDelete_atFirstIndex_deletesFirstCity() {
//    let expected = 0
//    sut.delete(at: IndexPath(row: 0, section: 0))
//
//    XCTAssertEqual(expected, sut.numberOfCities)
//  }
}
