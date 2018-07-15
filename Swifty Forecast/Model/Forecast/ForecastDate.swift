//
//  ForecastDate.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 27/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation


struct ForecastDate {
  private let timestamp: Int
  private var date: Date
  private var formatter: DateFormatter
  
  init(timestamp: Int) {
    self.timestamp = timestamp
    self.date = Date(timeIntervalSince1970: TimeInterval(timestamp))
    self.formatter = DateFormatter()
  }
}


// MARK: - CustomStringConvertible
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
  
  var time: String {
    formatter.dateStyle = .none
    formatter.timeStyle = .short
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