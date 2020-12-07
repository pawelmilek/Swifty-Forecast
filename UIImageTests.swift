import XCTest
@testable import SwiftyForecast

class UIImageTests: XCTestCase {
  func testInitImage_whenAlwaysTemplate_returnsImage() {
    let image = UIImage.makeAlwaysTemplate(named: Style.AddCalloutView.addButtonIconName)
    XCTAssertNotNil(image)
  }
}
