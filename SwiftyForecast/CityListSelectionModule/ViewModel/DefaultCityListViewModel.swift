import RealmSwift
import MapKit

final class DefaultCityListViewModel: CityListViewModel {
  var numberOfCities: Int {
    return cityViewModels.count
  }
  
  var onCitySelected: ((Int) -> Void)?
  var onInitialDataLoad: (() -> Void)?
  var onApplyListChanges: ((_ deletions: [Int], _ insertions: [Int], _ updates: [Int]) -> Void)?
  
  private var citiesToken: NotificationToken?
  
  private var storedCities: [CityDTO] = []
  
  private var cityArray: [CityDTO] {
    guard let cities = cityResults else { return [] }
    return cities.compactMap { ModelTranslator().translate($0) }
  }
  
  private var cityResults: Results<City>? {
    return cityDAO.getAll()
  }
  
  private var cityViewModels: [CityViewModel] {
    guard let cities = cityResults else { return [] }
    return cities.compactMap { DefaultCityViewModel(city: $0) }
  }
  
  private let cityDAO: CityDAO
  private let forecastDAO: ForecastDAO
  
  init(cityDAO: CityDAO = DefaultCityDAO(), forecastDAO: ForecastDAO = DefaultForecastDAO()) {
    self.cityDAO = cityDAO
    self.forecastDAO = forecastDAO
    self.storedCities = cityDAO.getAll().compactMap { ModelTranslator().translate($0) }
    
    citiesToken = cityResults?.observe { changes in
      switch changes {
      case .initial:
        self.onInitialDataLoad?()
        
      case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
        self.onApplyListChanges?(deletions, insertions, modifications)
        debugPrint("deletions: \(deletions)")
        debugPrint("insertions: \(insertions)")
        debugPrint("modifications: \(modifications)")
        
      case .error(let error):
        debugPrint(error)
      }
    }
  }
  
  func name(at index: Int) -> String {
    return cityViewModels[safe: index]?.name ?? InvalidReference.notApplicable
  }
  
  func localTime(at index: Int) -> String {
    return cityViewModels[safe: index]?.localTime ?? InvalidReference.notApplicable
  }
  
  func map(at index: Int) -> (annotation: MKPointAnnotation, region: MKCoordinateRegion)? {
    return cityViewModels[safe: index]?.map
  }
  
  func postNotificationLocationCityUpdated(at index: Int) {
    ForecastNotificationCenter.post(.reloadContentPageData,
                                    object: nil,
                                    userInfo: [NotificationCenterUserInfo.cityUpdatedAtIndex.key: index])
  }
  
  func postNotificationLocationRemovedFromList(at index: Int) {
    guard let deletedCity = storedCities[safe: index] else { return }
    storedCities.remove(at: index)

    ForecastNotificationCenter.post(.locationRemovedFromList,
                                    object: nil,
                                    userInfo: [NotificationCenterUserInfo.cityUpdated.key: deletedCity])
  }
  
  func onViewDeinit() {
    citiesToken?.invalidate()
  }
}

// MARK: - CRUD
extension DefaultCityListViewModel {
  
  func select(at index: Int) {
    guard let _ = cityArray[safe: index] else { return }
    onCitySelected?(index)
  }
  
  func delete(at indexPath: IndexPath) {
    guard let cities = cityResults, cities.count >= indexPath.row else { return }
    guard let coordinate = cities[indexPath.row].location?.coordinate else { return }

    do {
      let city = cities[indexPath.row]
      try cityDAO.delete(city)
      
      if let forecast = forecastDAO.get(latitude: coordinate.latitude, longitude: coordinate.longitude) {
        try forecastDAO.delete(forecast)
      }
      
    } catch {
      debugPrint("File: \(#file), Function: \(#function), line: \(#line) delete city")
    }
  }
  
}