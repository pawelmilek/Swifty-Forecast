import Foundation
import RealmSwift

protocol CityDAO {
  init(realm: Realm?)

  func get(compoundKey: String) -> City?
  func getAll() -> Results<City>?
  func getAllResultOrderedByIndex() -> Results<City>?
  func getAllOrderedByIndex() -> [City]
  func put(_ city: City, sortIndex: Int) throws
  func put(_ city: City) throws
  func delete(_ city: City) throws
  func deleteAll() throws
  func update(compoundKey: String,
              timeZoneIdentifier: String,
              completion: @escaping (Result<String, GeocoderError>) -> Void) throws
}
