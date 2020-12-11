import Foundation
import RealmSwift

struct DefaultForecastDAO: ForecastDAO {
  private let realm: Realm?

  init(realm: Realm? = RealmProvider.core.realm) {
    self.realm = realm
  }

  func getAll() throws -> Results<ForecastResponse> {
    guard let realm = realm else { throw RealmError.initializationFailed }
    return realm.objects(ForecastResponse.self)
  }

  func get(latitude: Double, longitude: Double) -> ForecastResponse? {
    let compoundKey = "\(latitude)|\(longitude)"
    let forecast = try? getAll().filter("compoundKey = %@", compoundKey).first
    return forecast
  }

  func put(_ forecast: ForecastResponse) {
    guard let realm = realm else { return }

    do {
      try realm.write {
        realm.add(forecast, update: .all)
      }
    } catch {
      fatalError("Adding new forecast response: Realm transaction error")
    }
  }

  func delete(_ forecast: ForecastResponse) throws {
    guard let realm = realm else { throw RealmError.initializationFailed }

    do {
      try realm.write {
        realm.delete(forecast)
      }
    } catch {
      throw RealmError.transactionFailed(description: "Deleting forecast response")
    }

  }

  func deleteAll() throws {
    guard let realm = realm else { throw RealmError.initializationFailed }

    do {
      try realm.write {
        realm.deleteAll()
      }
    } catch {
      throw RealmError.transactionFailed(description: "Deleting all forecast resposnes")
    }
  }
}
