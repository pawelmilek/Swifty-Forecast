//
//  ForecastDate.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 27/09/18.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation

struct ForecastDate {
  private let date: Date
  private let formatter: DateFormatter
  private let timestamp: Int
  
  init(timestamp: Int) {
    self.timestamp = timestamp
    self.date = Date(timeIntervalSince1970: TimeInterval(timestamp))
    self.formatter = DateFormatter()
  }
}


// MARK: - Various date formats
extension ForecastDate {
  
  var longDayMonth: String { // June 1
    formatter.dateFormat = "MMMM d"
    let date = formatter.string(from: self.date)
    return date
  }
  
  var mediumDayMonth: String {
    formatter.dateFormat = "dd MMM"
    let date = formatter.string(from: self.date)
    return date
  }
  
  var weekday: String {
    formatter.dateFormat = "EEEE"
    let weekday = formatter.string(from: date)
    return weekday
  }

}


// MARK: - Various time formats
extension ForecastDate {
  
  var time: String {
    formatter.timeStyle = .short
    formatter.dateStyle = .none
    let time = formatter.string(from: date)
    return time
  }
  
  func time(by timeZone: TimeZone?) -> String {
    guard let timeZone = timeZone else { return "N/A" }
    formatter.timeStyle = .short
    formatter.dateStyle = .none
    formatter.timeZone = timeZone
    let time = formatter.string(from: date)
    return time
  }
  
}


// MARK: - CustomStringConvertible
extension ForecastDate: CustomStringConvertible {
  
  var description: String {
    let textualRepresentation = "\(self.longDayMonth), \(self.weekday) \(self.time)"
    return textualRepresentation
  }
  
}


// MARK: - Decodable protocol
extension ForecastDate: Decodable {
  private enum CodingKeys: String, CodingKey {
    case time
  }
  
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let timestamp = try container.decode(Int.self, forKey: .time)
    
    self.init(timestamp: timestamp)
  }
}



