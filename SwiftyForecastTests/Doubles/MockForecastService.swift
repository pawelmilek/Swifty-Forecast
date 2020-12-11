import Foundation
@testable import SwiftyForecast

final class MockForecastService: ForecastService {
  var successCompletion: (Result<ForecastResponse, WebServiceError>)!

  init(httpClient: HttpClient<ForecastResponse>, request: ForecastWebRequest) { }

  func getForecast(latitude: Double,
                   longitude: Double,
                   completion: @escaping (Result<ForecastResponse, WebServiceError>) -> Void) {
    completion(successCompletion)
  }
}
