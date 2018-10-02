//
//  Style.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 28/09/18.
//  Copyright © 2016 imac. All rights reserved.
//

import Foundation
import UIKit

struct Style {
  // MARK: - NavigationBar
  struct NavigationBar {
    static let barButtonItemColor = UIColor.blackShade
    static let titleTextColor = UIColor.blackShade
  }
  
  // MARK: - WeatherForecastWidget
  struct WeatherWidget {
    static let iconLabelFontSize = CGFloat(55)
    static let iconLabelTextColor = UIColor.white
    
    static let cityNameLabelFont = UIFont(name:  "HelveticaNeue-Light", size: 20)
    static let cityNameLabelTextColor = UIColor.blackShade
    static let cityNameLabelTextAlignment = NSTextAlignment.left
    static let cityNameLabelNumberOfLines = 1
    
    static let conditionSummaryLabelFont = UIFont(name:  "HelveticaNeue-Medium", size: 13)
    static let conditionSummaryLabelTextColor = UIColor.blackShade
    static let conditionSummaryLabelTextAlignment = NSTextAlignment.left
    static let conditionSummaryLabelNumberOfLines = 2
    
    static let humidityLabelFont = UIFont(name:  "HelveticaNeue-Medium", size: 13)
    static let humidityLabelTextColor = UIColor.blackShade
    static let humidityLabelTextAlignment = NSTextAlignment.left
    static let humidityLabelNumberOfLines = 1
    
    static let temperatureLabelFont = UIFont(name:  "HelveticaNeue-Light", size: 60)
    static let temperatureLabelTextColor = UIColor.blackShade
    static let temperatureLabelTextAlignment = NSTextAlignment.left
    static let temperatureLabelNumberOfLines = 1
    
    static let temperatureMaxMinLabelFont = UIFont(name:  "HelveticaNeue-Light", size: 16)
    static let temperatureMaxMinLabelTextColor = UIColor.blackShade
    static let temperatureMaxMinLabelTextAlignment = NSTextAlignment.left
    static let temperatureMaxMinLabelNumberOfLines = 1
  }
  
  // MARK: - CurrentForecastView
  struct CurrentForecast {
    static let backgroundColor = UIColor.clear
    static let shadowColor = UIColor.red.cgColor
    static let shadowOffset = CGSize(width: 0, height: 5)
    static let shadowOpacity: Float = 0.5
    static let shadowRadius: CGFloat = 10.0
    static let cornerRadius: CGFloat = 15.0
    
    static var conditionFontIconSize: CGFloat {
      if UIScreen.PhoneModel.isPhoneSE {
        return 70
        
      } else if UIScreen.PhoneModel.isPhone8 {
        return 100
        
      } else {
        return 130
      }
    }
    
    static let textColor = UIColor.white
    static let textAlignment = NSTextAlignment.center
    static let dateLabelFont = UIFont(name: "HelveticaNeue-Medium", size: 15)
    static let cityNameLabelFont = UIFont(name: "HelveticaNeue-Light", size: 12)
    static let temperatureLabelFont = UIFont(name: "HelveticaNeue-Light", size: 90)
  }
  
  
  // MARK: - ConditionView
  struct Condition {
    static let backgroundColor = UIColor.white.withAlphaComponent(0.3)
    static let cornerRadius: CGFloat = 5.0
    static let valueLabelFont = UIFont(name: "HelveticaNeue", size: 11)
    static let textColor = UIColor.white
    static let textAlignment = NSTextAlignment.center
    static let conditionFontSize = CGFloat(20)
    
  }
  
  
  // MARK: - CityTableViewCell
  struct CityCell {
    static let backgroundColor = UIColor.clear
    static let currentTimeLabelFont = UIFont(name: "HelveticaNeue-Medium", size: 15)
    static let currentTimeLabelTextColor = UIColor.blackShade
    static let currentTimeLabelTextAlignment = NSTextAlignment.left
    
    static let cityNameLabelFont = UIFont(name: "HelveticaNeue-Light", size: 20)
    static let cityNameLabelTextColor = UIColor.white
    static let cityNameLabelTextAlignment = NSTextAlignment.left
    
    static let separatorColor = UIColor.white.withAlphaComponent(0.8)
  }
  
  
  // MARK: - DailyForecastTableViewCell
  struct DailyForecastCell {
    static let backgroundColor = UIColor.clear
    
    static let dateLabelTextColor = UIColor.blackShade
    static let dateLabelTextAlignment = NSTextAlignment.left
    
    static let iconLabelTextColor = UIColor.blackShade
    static let iconLabelTextAlignment = NSTextAlignment.center
    
    static let temperatureLabelFont = UIFont(name: "HelveticaNeue-Light", size: 17)
    static let temperatureLabelTextColor = UIColor.blackShade
    static let temperatureLabelTextAlignment = NSTextAlignment.center
    
    static let weekdayLabelFont = UIFont(name: "HelveticaNeue-Medium", size: 11)!
    static let monthLabelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
    
    static let conditionFontIconSize: CGFloat = 22
  }
  
  // MARK: - HourlyForecastCollectionViewCell
  struct HourlyForecastCell {
    static let backgroundColor = UIColor.clear
    
    static let timeLabelFont = UIFont(name: "HelveticaNeue-Light", size: 11)
    static let timeLabelTextColor = UIColor.white
    static let timeLabelTextAlignment = NSTextAlignment.center
    
    static let iconLabelTextColor = UIColor.white
    static let iconLabelTextAlignment = NSTextAlignment.center
    
    static let temperatureLabelFont = UIFont(name: "HelveticaNeue-Medium", size: 13)
    static let temperatureLabelTextColor = UIColor.white
    static let temperatureLabelTextAlignment = NSTextAlignment.center
  }
  
  
  // MARK: - ForecastCityListTableViewController
  struct ForecastCityListVC {
    static let autocompleteVCPrimaryTextColor = UIColor.orange
    static let autocompleteVCPrimaryTextHighlightColor = UIColor.orange.withAlphaComponent(0.6)
    static let autocompleteVCSecondaryTextColor = UIColor.blackShade
    static let autocompleteVCTableCellSeparatorColor = UIColor.blackShade.withAlphaComponent(0.7)
    static let autocompleteVCSSearchTextColorInSearchBar = UIColor.orange
    static let autocompleteVCSSearchTextFontInSearchBar = UIFont.systemFont(ofSize: 14, weight: .light)
    static let autocompleteVCSearchTextFieldColorPlaceholder = UIColor.blackShade.withAlphaComponent(0.6)
    static let autocompleteVCSearchTextFieldFontPlaceholder = UIFont.systemFont(ofSize: 14, weight: .regular)
    static let autocompleteVCSearchBarCancelButtonColor = UIColor.orange
    static let autocompleteVCSearchBarCancelButtonFont = UIFont.systemFont(ofSize: 14, weight: .regular)

    static let tableViewBackgroundColor = UIColor.clear
  }
  
  
  // MARK: - ForecastContentViewController
  struct ForecastContentVC {
    static let tableViewBackgroundColor = UIColor.white
    static let tableViewSeparatorStyle = UITableViewCell.SeparatorStyle.none
  }
  
  
  // MARK: - ForecastMainViewController
  struct ForecastMainVC {
    static let measuringSystemSegmentedControlFont = UIFont(name: "HelveticaNeue-Medium", size: 14)
    static let measuringSystemSegmentedControlBorderWidth: CGFloat = 1.0
    static let measuringSystemSegmentedControlSelectedLabelColor = UIColor.white
    
    static let measuringSystemSegmentedControlUnselectedLabelColor = UIColor.blackShade
    static let measuringSystemSegmentedControlBorderColor = UIColor.blackShade
    static let measuringSystemSegmentedControlThumbColor = UIColor.blackShade
    static let measuringSystemSegmentedControlBackgroundColor = UIColor.clear
  }
  
  
  // MARK: - OfflineViewController
  struct OfflineVC {
    static let backgroundColor = UIColor.white
    static let descriptionLabelFont = UIFont.systemFont(ofSize: 13, weight: .regular)
    static let descriptionLabelTextColor = UIColor.blackShade
    static let descriptionLabelTextAlignment = NSTextAlignment.left
  }
  
  
  // MARK: - CitySearchBar
  struct CitySearchBar {
    static let backgroundColor = UIColor.ecstasy
    static let cancelButtonFont = UIFont.init(name: "AvenirNext-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .light)
    static let cancelButtonColor = UIColor.white
    static let cancelButtonBackgroundColor = UIColor.white
    
    static let searchTextFieldBackgroundColor = UIColor.white
    static let searchTextFieldFont = UIFont.init(name: "AvenirNext-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .light)
    static let searchTextFieldColor = UIColor.black
    static let searchTextFieldPlaceholder = UIColor.gray
    static var searchTextFieldTintColor = UIColor.ecstasy
    static let textFieldClearButtonColor = UIColor.gray
    static let glassIconColor = UIColor.gray
  }
  
}
