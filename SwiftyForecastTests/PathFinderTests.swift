import XCTest
@testable import SwiftyForecast

// swiftlint:disable force_try
// swiftlint:disable force_cast
class PathFinderTests: XCTestCase {
  private let plistFileName = "ReviewDesirableMomentConfig.plist"
  private let dummyFileName = "test-file-name"
  private let sut = PathFinder.self

  func testInLibrary_getsFileURL() {
    let expected = dummyFileName

    let path = try! sut.inLibrary(dummyFileName).lastPathComponent
    XCTAssertEqual(expected, path)
  }

  func testInDocuments_getsFileURL() {
    let expected = dummyFileName

    let path = try! sut.inDocuments(dummyFileName).lastPathComponent
    XCTAssertEqual(expected, path)
  }

  func testInMainBundle_throwsPathErrorNotFound() {
    let expected = "Resource not found"
    XCTAssertThrowsError(try sut.inMainBundle(dummyFileName)) { error in
      let pathError = error as! PathError
      XCTAssertEqual(expected, pathError.errorDescription)
    }
  }

  func testInMainBundle_getPlistFileURL() {
    let expected = plistFileName
    let lastPathComponent = try! sut.inMainBundle(plistFileName).lastPathComponent
    XCTAssertEqual(expected, lastPathComponent)
  }

  func testInSharedContainer_getsFileContainerURL() {
    let expected = dummyFileName
    let lastPathComponent = try! sut.inSharedContainer(dummyFileName).lastPathComponent
    XCTAssertEqual(expected, lastPathComponent)
  }

  func testDocuments_getsDecumentsURLLastPathComponent() {
    let expected = "Documents"
    let filePath = try! sut.documents().lastPathComponent
    XCTAssertEqual(expected, filePath)
  }
}
