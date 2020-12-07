import Foundation
import RealmSwift

struct DefaultForecastDAO: ForecastDAO {
  func get(latitude: Double, longitude: Double) -> ForecastResponse? {
    let compoundKey = "\(latitude)|\(longitude)"
    let forecast = try? ForecastResponse.fetchAll().filter("compoundKey = %@", compoundKey).first
    return forecast
  }

  func put(_ forecast: ForecastResponse) {
    do {
      try ForecastResponse.add(forecast)
    } catch {
      fatalError("Realm transaction error")
    }

  }

  func delete(_ forecast: ForecastResponse) throws {
    try forecast.delete()
  }

  func deleteAll() throws {
    try ForecastResponse.deleteAll()
  }
}
