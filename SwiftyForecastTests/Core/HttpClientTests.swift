import XCTest
@testable import SwiftyForecast

// swiftlint:disable force_try
class HttpClientTests: XCTestCase {
  private var sut: HttpClient<[String: String]>!
  private var session: MockURLSession!

  override func setUp() {
    super.setUp()
    session = MockURLSession()
    sut = HttpClient(session: session)
  }

  override func tearDown() {
    super.tearDown()

    session = nil
    sut = nil
  }

  func testGetRequestSuccessResult() {
    let webRequest = MockForecastWebRequest()
    let expectedResult = ["summary": "Mixed precipitation throughout the day."]
    let data = try! JSONSerialization.data(withJSONObject: expectedResult, options: .prettyPrinted)

    session.data = data

    var requestResult: [String: String]!

    sut.get(by: webRequest) { result in
      switch result {
      case .success(let data):
        requestResult = data

      case .failure:
        requestResult = nil
      }
    }

    XCTAssertEqual(requestResult, expectedResult)
  }

  func testGetRequestFailureResult() {
    let webRequest = MockForecastWebRequest()
    session.data = nil

    var requestResult: WebServiceError!

    sut.get(by: webRequest) { result in
      switch result {
      case .success:
        requestResult = nil

      case .failure(let error):
        requestResult = error
      }
    }

    XCTAssertNotNil(requestResult)
  }

}
