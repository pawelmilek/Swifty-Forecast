import MapKit
import RealmSwift

// swiftlint:disable force_try
struct DefaultCityCellViewModel: CityCellViewModel {
  var name: String {
    guard let city = city else { return "" }
    return city.name + ", " + city.country
  }

  var localTime: String {
    guard let city = city else { return "" }
    return city.localTime
  }

  var onSuccessTimeZoneGecoded: (() -> Void)?

  var miniMapData: (annotation: MKPointAnnotation, region: MKCoordinateRegion)? {
    guard let city = city else { return nil }

    let mkPlacemark = MKPlacemark(placemark: city.placemark)
    let annotation = MKPointAnnotation()
    annotation.coordinate = mkPlacemark.coordinate
    annotation.title = mkPlacemark.name
    if let city = mkPlacemark.locality, let state = mkPlacemark.administrativeArea {
      annotation.subtitle = "\(city) \(state)"
    }

    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    let region = MKCoordinateRegion(center: mkPlacemark.coordinate, span: span)
    return (annotation: annotation, region: region)
  }

  private let cityDAO: CityDAO
  private let timeZoneLoader: TimeZoneLoadable
  private let realm: Realm?
  private let city: CityDTO?

  init(cityCompoundKey: String,
       cityDAO: CityDAO = DefaultCityDAO(),
       timeZoneLoader: TimeZoneLoadable = TimeZoneLoader(),
       realm: Realm? = RealmProvider.core.realm) {

    self.cityDAO = cityDAO
    self.timeZoneLoader = timeZoneLoader
    self.realm = realm
    self.city = ModelTranslator().translate(cityDAO.get(compoundKey: cityCompoundKey))
  }

  func loadTimeZone(completion: @escaping (Result<String, GeocoderError>) -> Void) -> UUID? {
    guard let cityWithoutTimeZone = city, localTime == InvalidReference.notApplicable else {
      completion(.success(city!.timeZoneIdentifier))
      return nil
    }

    let result = timeZoneLoader.load(for: (cityWithoutTimeZone.latitude, cityWithoutTimeZone.longitude)) { result in
      switch result {
      case .success(let timeZone):
        try! cityDAO.update(compoundKey: cityWithoutTimeZone.compoundKey,
                            timeZoneIdentifier: timeZone.identifier,
                            completion: completion)

      case .failure(let error):
        debugPrint("File: \(#file), Function: \(#function), line: \(#line) \(error)")
      }
    }

    return result
  }

  func cancelLoad(_ uuid: UUID) {
    timeZoneLoader.cancel(uuid)
  }
}
