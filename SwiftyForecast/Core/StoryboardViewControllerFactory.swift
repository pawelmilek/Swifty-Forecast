import UIKit

// swiftlint:disable identifier_name
struct StoryboardViewControllerFactory {

  static func make<T: UIViewController>(_ vc: T.Type, from storyboard: UIStoryboard.Storyboard) -> T {
    let storyboard = UIStoryboard(storyboard: storyboard)
    return storyboard.instantiateViewController(vc.self)
  }

}
