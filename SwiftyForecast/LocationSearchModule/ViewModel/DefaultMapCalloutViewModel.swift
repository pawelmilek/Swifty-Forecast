import UIKit
import MapKit

struct DefaultMapCalloutViewModel: MapCalloutViewModel {
  var cityName: String { cityDataTransferObject?.name ?? InvalidReference.notApplicable }
  var country: String { cityDataTransferObject?.country ?? InvalidReference.notApplicable }

  private weak var delegate: MapCalloutViewControllerDelegate?
  private let city: City
  private let cityDataTransferObject: CityDTO?
  private let dataAccessObject: CityDAO
  private let modelTranslator: ModelTranslator

  init(placemark: MKPlacemark,
       delegate: MapCalloutViewControllerDelegate?,
       dataAccessObject: CityDAO = DefaultCityDAO(),
       modelTranslator: ModelTranslator = ModelTranslator()) {
    self.city = City(placemark: placemark, isUserLocation: false)
    self.cityDataTransferObject = modelTranslator.translate(city)
    self.delegate = delegate
    self.dataAccessObject = dataAccessObject
    self.modelTranslator = modelTranslator
  }

  func addCityToLocationList() {
    guard let cityDao = cityDataTransferObject else { return }

    do {
      if !isExisting(cityDao) {
        try dataAccessObject.put(city)
      }

      delegate?.calloutViewController(didAdd: cityDao)
      AppStoreReviewNotifier.notify(.locationAdded)
    } catch {
      debugPrint("File: \(#file), Function: \(#function), line: \(#line) \(RealmError.initializationFailed)")
    }
  }

  private func isExisting(_ city: CityDTO) -> Bool {
    guard dataAccessObject.getAllResultOrderedByIndex()?.first { $0.compoundKey == city.compoundKey } != nil else {
      return false
    }
    return true
  }
}
