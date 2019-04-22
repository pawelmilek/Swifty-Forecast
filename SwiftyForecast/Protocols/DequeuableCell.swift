//
//  DequeuableCell.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 26/09/18.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import UIKit


protocol DequeuableCell: AnyObject {}


extension DequeuableCell where Self: UITableView {
  
  func dequeueCell<T: UITableViewCell>(_ ofType: T.Type, for indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
      fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
    }
    
    return cell
  }
  
}
