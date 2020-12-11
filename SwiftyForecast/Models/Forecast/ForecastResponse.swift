import RealmSwift
import CoreLocation

@objcMembers final class ForecastResponse: Object, Decodable {
  dynamic var compoundKey = "0|0"
  dynamic var timezone = ""
  dynamic var latitude = 0.0
  dynamic var longitude = 0.0
  dynamic var currently: CurrentForecast?
  dynamic var hourly: HourlyForecast?
  dynamic var daily: DailyForecast?
  dynamic var lastUpdate = Date()

  private enum CodingKeys: String, CodingKey {
    case timezone
    case latitude
    case longitude
    case currently
    case hourly
    case daily
  }

  private var compoundKeyValue: String {
    "\(self.latitude)|\(self.longitude)"
  }

  var location: CLLocation {
    return CLLocation(latitude: latitude, longitude: longitude)
  }

  convenience init(timezone: String,
                   latitude: Double,
                   longitude: Double,
                   currently: CurrentForecast,
                   hourly: HourlyForecast,
                   daily: DailyForecast) {
    self.init()
    self.timezone = timezone
    self.latitude = latitude
    self.longitude = longitude
    self.currently = currently
    self.hourly = hourly
    self.daily = daily
    self.compoundKey = compoundKeyValue
  }

  required convenience init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let timezone = try container.decode(String.self, forKey: .timezone)
    let latitude = try container.decode(Double.self, forKey: .latitude)
    let longitude = try container.decode(Double.self, forKey: .longitude)
    let currently = try container.decode(CurrentForecast.self, forKey: .currently)
    let hourly = try container.decode(HourlyForecast.self, forKey: .hourly)
    let daily = try container.decode(DailyForecast.self, forKey: .daily)

    self.init(timezone: timezone,
              latitude: latitude,
              longitude: longitude,
              currently: currently,
              hourly: hourly,
              daily: daily)
  }

  required init() {
    super.init()
  }

  override static func primaryKey() -> String? {
    "compoundKey"
  }
}
