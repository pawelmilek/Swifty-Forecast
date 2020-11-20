import Foundation
import RealmSwift
@testable import SwiftyForecast

final class TestCityDAO: CityDAO {
  var hasGetAllResult = false
  var hasGetAllOrderedByIndex = false
  var hasPutSortIndex = false
  var hasPut = false
  var hasDelete = false
  var hasDeleteAll = false
  
  func getAllResultOrderedByIndex() -> Results<City>? {
    hasGetAllResult = true
    return nil
  }
  
  func getAllOrderedByIndex() -> [City] {
    hasGetAllOrderedByIndex = true
    return []
  }
  
  func put(_ city: City, sortIndex: Int) throws {
    hasPutSortIndex = true
  }
  
  func put(_ city: City) throws {
    hasPut = true
  }
  
  func delete(_ city: City) throws {
    hasDelete = true
  }
  
  func deleteAll() throws {
    hasDeleteAll = true
  }
  
}
