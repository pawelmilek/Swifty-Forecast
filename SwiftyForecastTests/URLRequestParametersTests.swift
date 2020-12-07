import XCTest
@testable import SwiftyForecast

class URLRequestParametersTests: XCTestCase {

  func testEncode_setParameter_gestEncodedURL() {
    let urlRequest = URLRequest(url: URL(fileURLWithPath: "test-url-path"))
    let parameters = ["test": "parameter"]
    let sut = urlRequest.encode(with: parameters)

    let expected = "file:///test-url-path?test=parameter"
    XCTAssertEqual(expected, sut.description)
  }
}
