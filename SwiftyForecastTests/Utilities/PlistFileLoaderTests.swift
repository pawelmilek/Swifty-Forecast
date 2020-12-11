import XCTest
@testable import SwiftyForecast

// swiftlint:disable force_cast
// swiftlint:disable xctfail_message
// swiftlint:disable line_length
class PlistFileLoaderTests: XCTestCase {
  private var bundle: Bundle!

  override func setUp() {
    super.setUp()
    bundle = Bundle(for: type(of: self))
  }

  override func tearDown() {
    bundle = nil
    super.tearDown()
  }

  func testVerboseDictionaryResult() throws {
    let sut: [String: Int] = try PlistFileLoader.loadPropertyListSerialization(with: "ReviewDesirableMomentConfig_Test",
                                                                               bundle: bundle)
    XCTAssertEqual(sut["locationCount"], 22)
    XCTAssertEqual(sut["detailsInteractionCount"], 999)
    XCTAssertEqual(sut["minEnjoyableTemperatureInFahrenheit"], 100)
    XCTAssertEqual(sut["maxEnjoyableTemperatureInFahrenheit"], 1000)
  }

  func testDecodableReviewDesirableMomentConfigResult() throws {
    let sut: ReviewDesirableMomentConfig = try PlistFileLoader.loadPropertyListDecodable(with: "ReviewDesirableMomentConfig_Test",
                                                                                         bundle: bundle)
    XCTAssertEqual(sut.locationCount, 22)
    XCTAssertEqual(sut.detailsInteractionCount, 999)
    XCTAssertEqual(sut.minEnjoyableTemperatureInFahrenheit, 100)
    XCTAssertEqual(sut.maxEnjoyableTemperatureInFahrenheit, 1000)
  }

  func testThrowingFileNotFoundException() {
    let fileName = "not-existing-file-name-test"
    do {
      let _: [String: Int] = try PlistFileLoader.loadPropertyListDecodable(with: fileName, bundle: bundle)
    } catch {
      switch error as! FileLoaderError {
      case .fileNotFound(let file):
        XCTAssertEqual(fileName, file)

      default:
        XCTFail()
      }
    }
  }

  func testThrowingIncorrectFormatException() {
    do {
      let _: [String] = try PlistFileLoader.loadPropertyListDecodable(with: "ReviewDesirableMomentConfig_Test",
                                                                      bundle: bundle)
    } catch {
      switch error as! FileLoaderError {
      case .incorrectFormat:
        XCTAssertTrue(true)

      default:
        XCTFail()
      }
    }
  }
}
