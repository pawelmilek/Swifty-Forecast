import XCTest
import MapKit
import Contacts
@testable import SwiftyForecast

class LocationSearchResultsViewModelTests: XCTestCase {
  private var sut: LocationSearchResultsViewModel!
  private var chicagoMapItem: MKMapItem {
    let location = CLLocation(latitude: 41.878113, longitude: -87.629799)
    let postalAddress = CNMutablePostalAddress()
    postalAddress.state = "IL"
    postalAddress.city = "Chicago"
    postalAddress.postalCode = "12345"
    postalAddress.country = "US"

    let placemark = CLPlacemark(location: location, name: "Chicago", postalAddress: postalAddress)
    let mapItem = MKMapItem(placemark: MKPlacemark(placemark: placemark))
    return mapItem
  }

  override func setUp() {
    super.setUp()

    sut = DefaultLocationSearchResultsViewModel()
    sut.matchingItems = [chicagoMapItem]
  }

  override func tearDown() {
    sut = nil
    super.tearDown()
  }

  func testMatchingItemsCount_whenOneMachingItem_returnsOne() {
    XCTAssertEqual(1, sut.matchingItemsCount)
  }

  func testItem_atFirstIndex_returnsChicagoPlacemark() {
    let coordinate = CLLocationCoordinate2D(latitude: 41.878113, longitude: -87.629799)
    let placemark = MKPlacemark(coordinate: coordinate)
    let expected = placemark.coordinate
    let item = sut.item(at: 0)!

    XCTAssertEqual(expected.latitude, item.coordinate.latitude)
    XCTAssertEqual(expected.longitude, item.coordinate.longitude)
  }

  func testName_atFirstIndex_returnsChicago() {
    XCTAssertEqual("Chicago", sut.name(at: 0)!)
  }

  func testAddress_atFirstIndex_returnsChicago() {
    let expected = "ChicagoIL"

    XCTAssertEqual(expected, sut.address(at: 0)!)
  }
}
