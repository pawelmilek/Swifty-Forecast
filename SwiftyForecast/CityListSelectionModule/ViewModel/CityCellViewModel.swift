import MapKit
import RealmSwift

protocol CityCellViewModel {
  var name: String { get }
  var localTime: String { get }
  var miniMapData: (annotation: MKPointAnnotation, region: MKCoordinateRegion)? { get }
  var onSuccessTimeZoneGecoded: (() -> Void)? { get set }

  init(cityCompoundKey: String, cityDAO: CityDAO, timeZoneLoader: TimeZoneLoadable, realm: Realm?)

  func loadTimeZone(completion: @escaping (Result<String, GeocoderError>) -> Void) -> UUID?
  func cancelLoad(_ uuid: UUID)
}
