import Foundation
@testable import SwiftyForecast

class MockTimeZoneLoader: TimeZoneLoadable {
  var onLoadCompletionResult: (Result<TimeZone, GeocoderError>)!
  var onCancelRunningRequests = false

  func load(for coordinate: Location, completion: @escaping (Result<TimeZone, GeocoderError>) -> Void) -> UUID? {
    completion(onLoadCompletionResult)
    return UUID()
  }

  func cancel(_ uuid: UUID) {
    onCancelRunningRequests = true
  }
}
