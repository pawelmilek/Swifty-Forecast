import Foundation
import RealmSwift
import Intents
import Contacts

struct DefaultCityDAO: CityDAO {
  private let realm: Realm?

  init(realm: Realm? = RealmProvider.core.realm) {
    self.realm = realm
  }

  func get(compoundKey: String) -> City? {
    guard let realm = realm else { return nil }
    let city = realm.objects(City.self).first(where: { $0.compoundKey == compoundKey })
    return city
  }

  func getAll() -> Results<City>? {
    guard let realm = realm else { return nil }
    return realm.objects(City.self)
  }

  func getAllResultOrderedByIndex() -> Results<City>? {
    guard let realm = realm else { return nil }

    let sortDescriptors = [SortDescriptor(keyPath: CityProperty.orderIndex.key, ascending: true),
                           SortDescriptor(keyPath: CityProperty.isUserLocation.key, ascending: false)]
    return realm.objects(City.self).sorted(by: sortDescriptors)

  }

  func getAllOrderedByIndex() -> [City] {
    guard let realm = realm else { return [] }

    let sortDescriptors = [SortDescriptor(keyPath: CityProperty.orderIndex.key, ascending: true),
                           SortDescriptor(keyPath: CityProperty.isUserLocation.key, ascending: false)]
    return Array(realm.objects(City.self).sorted(by: sortDescriptors))
  }

  func put(_ city: City, sortIndex: Int) throws {
    guard let realm = realm else { throw RealmError.initializationFailed }

    do {
      city.orderIndex = sortIndex

      try realm.write {
        realm.add(city, update: .all)
      }
    } catch {
      throw RealmError.transactionFailed(description: "Adding new city")
    }
  }

  func put(_ city: City) throws {
    guard let realm = realm else { throw RealmError.initializationFailed }

    do {
      city.orderIndex = nextSortIndex(in: realm)

      try realm.write {
        realm.add(city, update: .all)
      }
    } catch {
      throw RealmError.transactionFailed(description: "Adding new city")
    }
  }

  func delete(_ city: City) throws {
    guard let realm = realm else { throw RealmError.initializationFailed }

    do {
      try realm.write {
        realm.delete(city)
      }
    } catch {
      throw RealmError.transactionFailed(description: "Deleting city")
    }
  }

  func deleteAll() throws {
    guard let realm = realm else { throw RealmError.initializationFailed }

    do {
      try realm.write {
        realm.deleteAll()
      }
    } catch {
      throw RealmError.transactionFailed(description: "Deleting all cities")
    }
  }

  func update(compoundKey: String,
              timeZoneIdentifier: String,
              completion: @escaping (Result<String, GeocoderError>) -> Void) throws {
    guard let realm = realm else {
      throw RealmError.initializationFailed
    }
    guard let city = get(compoundKey: compoundKey) else {
      throw RealmError.transactionFailed(description: "Getting city")
    }

    do {
      try realm.write {
        city.timeZoneIdentifier = timeZoneIdentifier
        completion(.success(timeZoneIdentifier))
      }
    } catch {
      throw RealmError.transactionFailed(description: "Deleting city")
    }
  }

  private func nextSortIndex(in realm: Realm? = RealmProvider.core.realm) -> Int {
    return (realm?.objects(City.self).map { $0.orderIndex }.max() ?? 0) + 1
  }
}
