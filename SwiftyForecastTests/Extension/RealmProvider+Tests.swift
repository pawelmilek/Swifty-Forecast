import Foundation
import RealmSwift
@testable import SwiftyForecast

// swiftlint:disable force_try
extension RealmProvider {

  var fakeForTesting: RealmProvider {
    var config = self.configuration
    config.inMemoryIdentifier = UUID().uuidString
    config.readOnly = false
    return RealmProvider(config: config)
  }

}

// MARK: - Add for testing
extension Realm {

  func addForTesting(objects: [Object]) {
    try! write {
      add(objects)
    }
  }

}
