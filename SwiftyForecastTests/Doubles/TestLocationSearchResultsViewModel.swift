import Foundation
import MapKit
@testable import SwiftyForecast

class TestLocationSearchResultsViewModel: LocationSearchResultsViewModel {
  var isSearchSearchResultUpdated = false

  var matchingItems: [MKMapItem] = []

  var matchingItemsCount: Int { matchingItems.count }

  var onUpdateSearchResults: (() -> Void)?

  func item(at index: Int) -> MKPlacemark? { nil }

  func name(at index: Int) -> String? { nil }

  func address(at index: Int) -> String? { nil }

  func localSearchRequest(search text: String, at region: MKCoordinateRegion) {
    isSearchSearchResultUpdated = true
  }
}
