//
//  WeatherFontIcon.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 04/07/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

protocol FontWeatherIcon {
  associatedtype T: FontWeatherIcon
  var attributedIcon: NSAttributedString { get }
  
  static func make(icon: String, font size: CGFloat) -> T?
}
