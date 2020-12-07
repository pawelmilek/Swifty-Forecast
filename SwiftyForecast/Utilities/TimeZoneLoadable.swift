import Foundation

protocol TimeZoneLoadable {
  typealias Location = (latitude: Double, longitude: Double)

  func load(for coordinate: Location, completion: @escaping (Result<TimeZone, GeocoderError>) -> Void) -> UUID?
  func cancel(_ uuid: UUID)
}
