import RealmSwift

protocol ForecastDAO {
  init(realm: Realm?)

  func getAll() throws -> Results<ForecastResponse>
  func get(latitude: Double, longitude: Double) -> ForecastResponse?
  func put(_ forecast: ForecastResponse)
  func delete(_ forecast: ForecastResponse) throws
  func deleteAll() throws
}
