import XCTest
@testable import SwiftyForecast

// swiftlint:disable force_cast
// swiftlint:disable xctfail_message
class JSONFileLoaderTests: XCTestCase {
  private var bundle: Bundle!

  override func setUp() {
    super.setUp()
    bundle = Bundle(for: type(of: self))
  }

  override func tearDown() {
    bundle = nil
    super.tearDown()
  }

  func testThrowingFileNotFoundException() {
    let fileName = "ghost-file-not-existing"
    XCTAssertThrowsError(try JSONFileLoader.loadFile(with: fileName, bundle: bundle)) { error in
      if case let .fileNotFound(fileName) = (error as! FileLoaderError) {
        XCTAssertEqual(fileName, fileName)
      }
    }
  }

  func testLaodingChicagoForecast() throws {
    let sut = try JSONFileLoader.loadFile(with: "forecastChicagoStub", bundle: bundle)
    let result = NetworkResponseParser<ForecastResponse>.parseJSON(sut)

    switch result {
    case .success(let data):
      XCTAssertEqual(data.compoundKey, "41.8781136|-87.6297982")

    default:
        XCTFail()
    }
  }
}
