import UIKit

final class ContentViewController: UIViewController {
  @IBOutlet private weak var forecastView: ForecastView!
  @IBOutlet private weak var weekTableView: UITableView!
  
  private var dailyForecastTableViewBottomConstraint: NSLayoutConstraint?
  private var forecastViewMoreDetailsViewBottomConstraint: NSLayoutConstraint?
  private var forecastViewStackViewBottomToMoreDetailsBottomConstraint: NSLayoutConstraint?
  private var forecastViewStackViewBottomToSafeAreaBottomConstraint: NSLayoutConstraint?
  
  var city: City?
  
  var pageIndex: Int {
    get {
      return viewModel?.pageIndex ?? 0
    }
    
    set {
      viewModel?.pageIndex = newValue
    }
  }
  
  var viewModel: CurrentForecastViewModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUp()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchForecast()
  }
  
  deinit {
    removeNotificationObservers()
  }
}

// MARK: - ViewSetupable protocol
extension ContentViewController: ViewSetupable {
  
  func setUp() {
    setWeekTableView()
    arrangeConstraints()
    setViewModelClosureCallbacks()
    addNotificationObservers()
  }
  
}

// MARK: - Private - Arrange constraints
private extension ContentViewController {
  
  func arrangeConstraints() {
    forecastViewMoreDetailsViewBottomConstraint = forecastView.moreDetailsViewBottomConstraint
    forecastViewStackViewBottomToMoreDetailsBottomConstraint = forecastView.stackViewBottomToMoreDetailsTopConstraint
    forecastViewStackViewBottomToSafeAreaBottomConstraint = forecastView.stackViewBottomToSafeAreaBottomConstraint
    dailyForecastTableViewBottomConstraint = forecastView.bottomAnchor.constraint(equalTo: weekTableView.bottomAnchor,
                                                                                         constant: 0)
  }
  
}

// MARK: - Private - Set daily Forecast TableView
private extension ContentViewController {
  
  func setWeekTableView() {
    weekTableView.register(cellClass: DailyForecastTableViewCell.self)
    weekTableView.dataSource = self
    weekTableView.delegate = self
    weekTableView.showsVerticalScrollIndicator = false
    weekTableView.allowsSelection = false
    weekTableView.rowHeight = UITableView.automaticDimension
    weekTableView.estimatedRowHeight = 85
    weekTableView.backgroundColor = Style.ForecastContentVC.tableViewBackgroundColor
    weekTableView.separatorStyle = Style.ForecastContentVC.tableViewSeparatorStyle
    weekTableView.tableFooterView = UIView()
  }
  
}

// MARK: - Private - Add notification center
private extension ContentViewController {
  
  func addNotificationObservers() {
    ForecastNotificationCenter.add(observer: self, selector: #selector(unitNotationDidChange), for: .unitNotationDidChange)
    ForecastNotificationCenter.add(observer: self, selector: #selector(locationServiceDidBecomeEnable), for: .locationServiceDidBecomeEnable)
    ForecastNotificationCenter.add(observer: self, selector: #selector(applicationDidBecomeActive), for: .applicationDidBecomeActive)
  }
  
  func removeNotificationObservers() {
    ForecastNotificationCenter.remove(observer: self)
  }
  
}

// MAKR: - Private - Set view models closures
private extension ContentViewController {
  
  func setViewModelClosureCallbacks() {
    viewModel?.onSuccess = {
      DispatchQueue.main.async { [weak self] in
        self?.reloadAndInitializeMainPageViewController()
        self?.reloadDataInMainPageViewController()
        self?.reloadData()
      }
    }
    
    viewModel?.onFailure = { error in
      DispatchQueue.main.async {
        if case GeocoderError.locationDisabled = error {
          LocationProvider.shared.presentLocationServicesSettingsPopupAlert()
        } else {
          (error as? ErrorHandleable)?.handler()
        }
      }
    }
    
    viewModel?.onLoadingStatus = { [weak self] isLoading in
      guard let self = self else { return }
      isLoading
        ? ActivityIndicatorView.shared.startAnimating(at: self.view)
        : ActivityIndicatorView.shared.stopAnimating()
    }
  }
  
}

// MAKR: - Private - Fetch weather forecast
private extension ContentViewController {
  
  func fetchForecast() {
    viewModel?.loadData()
  }
  
}

// MARK: - Private - Reload pages
private extension ContentViewController {
  
  func reloadAndInitializeMainPageViewController() {
    ForecastNotificationCenter.post(.reloadPages)
  }
  
  func reloadDataInMainPageViewController() {
    ForecastNotificationCenter.post(.reloadPagesData)
  }
  
}

// MARK: - ForecastViewDelegate protocol
extension ContentViewController: ForecastViewDelegate {
  
  func currentForecastDidExpand() {
    animateBouncingEffect()
    
    forecastViewMoreDetailsViewBottomConstraint?.constant = 0
    dailyForecastTableViewBottomConstraint?.isActive = true
    forecastViewStackViewBottomToSafeAreaBottomConstraint?.isActive = false
    forecastViewStackViewBottomToMoreDetailsBottomConstraint?.isActive = true
    
    UIView.animate(withDuration: 0.5,
                   delay: 0.1,
                   usingSpringWithDamping: 1,
                   initialSpringVelocity: 1,
                   options: .curveEaseOut,
                   animations: {
                    self.forecastView.animateLabelsScaling()
                    self.view.layoutIfNeeded()
    })
  }
  
  func currentForecastDidCollapse() {
    let height = forecastView.frame.size.height
    
    forecastViewMoreDetailsViewBottomConstraint?.constant = height
    dailyForecastTableViewBottomConstraint?.isActive = false
    forecastViewStackViewBottomToSafeAreaBottomConstraint?.isActive = true
    forecastViewStackViewBottomToMoreDetailsBottomConstraint?.isActive = false
    
    UIView.animate(withDuration: 0.5,
                   delay: 0.1,
                   usingSpringWithDamping: 1,
                   initialSpringVelocity: 1,
                   options: .curveEaseIn,
                   animations: {
                    self.forecastView.animateLabelsIdentity()
                    self.view.layoutIfNeeded()
    })
  }
  
}

// MARK: - Private - Animate bouncing effect
private extension ContentViewController {
  
  func animateBouncingEffect() {
    forecastView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    
    UIView.animate(withDuration: 1.8,
                   delay: 0, usingSpringWithDamping: 0.2,
                   initialSpringVelocity: 6.0,
                   options: .allowUserInteraction,
                   animations: {
                    self.forecastView.transform = .identity
    })
  }
  
}

// MARK: - UITableViewDataSource protcol
extension ContentViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel?.numberOfDays ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let dailyItems = viewModel?.sevenDaysData,
      let item = dailyItems[safe: indexPath.row] else { return UITableViewCell() }
    
    let viewModel = DefaultDailyForecastCellViewModel(dailyData: item)
    let cell = tableView.dequeueCell(DailyForecastTableViewCell.self, for: indexPath)
    cell.configure(by: viewModel)
    return cell
  }
  
}

// MARK: - UITableViewDelegate protocol
extension ContentViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40
  }
  
}

// MARK: - Actions
extension ContentViewController {
  
  @objc func unitNotationDidChange(_ notification: NSNotification) {
    guard let userInfoKey = viewModel?.userInfoSegmentedControlChangeKey else { return }
    guard let segmentedControl = notification.userInfo?[userInfoKey] as? SegmentedControl else { return }
    guard let unitNotation = UnitNotation(rawValue: segmentedControl.selectedIndex) else { return }

    NotationSystem.selectedUnitNotation = unitNotation
    reloadData()
  }
  
  @objc func locationServiceDidBecomeEnable(_ notification: NSNotification) {
    viewModel?.fetchCurrentLocationForecast()
  }
  
  @objc func applicationDidBecomeActive(_ notification: NSNotification) {
    fetchForecast()
  }
  
  private func reloadData() {
    guard let viewModel = viewModel else { return }
    
    DispatchQueue.main.async { [weak self] in
      self?.forecastView.configure(by: viewModel)
      self?.weekTableView.reloadData()
    }
  }
  
}

// MARK: - Factory method
extension ContentViewController {
  
  static func make(viewModel: CurrentForecastViewModel) -> ContentViewController {
    let viewController = StoryboardViewControllerFactory.make(ContentViewController.self)
    viewController.viewModel = viewModel
    return viewController
  }
  
}
