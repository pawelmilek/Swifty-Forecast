import Foundation
import RealmSwift

// swiftlint:disable force_try
struct RealmProvider {
  static var core: RealmProvider = {
    return RealmProvider(config: coreConfig)
  }()

  private static let coreConfig = Realm.Configuration(fileURL: try! PathFinder.inLibrary("core.realm"),
                                                      schemaVersion: 1,
                                                      deleteRealmIfMigrationNeeded: true)

  let configuration: Realm.Configuration
  var realm: Realm {
    do {
      return try Realm(configuration: configuration)
    } catch {
      fatalError(RealmError.initializationFailed.description)
    }
  }

  init(config: Realm.Configuration) {
    configuration = config
  }
}
