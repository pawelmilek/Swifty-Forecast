import Foundation

struct HourlyForecast {
  let summary: String
  let icon: String
  let data: [HourlyData]
}

// MARK: - Decodable protocol
extension HourlyForecast: Decodable {
  
  enum CodingKeys: String, CodingKey {
    case summary
    case icon
    case data
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.summary = try container.decode(String.self, forKey: .summary)
    self.icon = try container.decode(String.self, forKey: .icon)
    self.data = try Array(container.decode([HourlyData].self, forKey: .data).prefix(24))
  }
  
}