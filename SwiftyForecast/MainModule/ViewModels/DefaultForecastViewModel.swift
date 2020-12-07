import UIKit
import RealmSwift
import SafariServices
import MapKit
import Intents
import Contacts
import PMSegmentedControl

final class DefaultForecastViewModel: ForecastViewModel {
  private static let userLocationPageControlIndex = 0
  private static let userLocationSortIndex = 1
  private let dispatchGroup = DispatchGroup()

  var pendingIndex: Int?
  var currentIndex: Int = 0 {
    didSet {
      onIndexUpdate?(currentIndex)
    }
  }

  var numberOfCities: Int {
    allCities.count
  }

  var powerByURL: URL? {
    URL(string: "https://darksky.net/poweredby/")
  }

  var currentVisibleViewControllers: [UIViewController] {
    guard let visibleViewController = contentViewController(at: currentIndex) else { return [] }
    return [visibleViewController]
  }

  var onIndexUpdate: ((Int) -> Void)?
  var onLoadingStatus: ((Bool) -> Void)?
  var onSuccess: (() -> Void)?

  private var isLoadingData = false {
    didSet {
      onLoadingStatus?(isLoadingData)
    }
  }

  private var allCities: [CityDTO] {
    return cityDataAccessObject.getAllOrderedByIndex().compactMap { modelTranslator.translate($0) }
  }

  private var isUserLocationPage: Bool {
    return currentIndex == 0
  }

  private var contentViewModels: [ContentViewModel] = []
  private let repository: Repository
  private let cityDataAccessObject: CityDAO
  private let forecastDataAccessObject: ForecastDAO
  private let modelTranslator: ModelTranslator

  init(repository: Repository,
       cityDataAccessObject: CityDAO = DefaultCityDAO(),
       forecastDataAccessObject: ForecastDAO = DefaultForecastDAO(),
       modelTranslator: ModelTranslator = ModelTranslator()) {
    self.repository = repository
    self.cityDataAccessObject = cityDataAccessObject
    self.forecastDataAccessObject = forecastDataAccessObject
    self.modelTranslator = modelTranslator
  }

  func addContentViewModel(at index: Int) {
    guard let city = city(at: index) else { return }
    let viewModel = DefaultContentViewModel(city: city, repository: self.repository)

    if !checkIfExists(viewModel) {
      contentViewModels.append(viewModel)
    }
  }

  func removeContentViewModel(with location: LocationDTO) {
    guard let viewModel = contentViewModels.first(where: { $0.location == location }) else { return }
    guard let indexToRemove = contentViewModels.firstIndex(where: { $0.location == viewModel.location }) else { return }
    contentViewModels.remove(at: indexToRemove)
  }

  func city(at index: Int) -> CityDTO? {
    let city = allCities[safe: index]
    return city
  }

  func index(of city: CityDTO) -> Int? {
    let index = allCities.firstIndex(where: { $0.compoundKey == city.compoundKey })
    return index
  }

  func contentViewController(at index: Int) -> ContentViewController? {
    guard let contentViewModel = contentViewModels[safe: index] else {
      return nil
    }

    let viewController = ContentViewController.make(viewModel: contentViewModel)
    viewController.pageIndex = index
    return viewController
  }

  func loadAllData() {
    isLoadingData = true

    for (index, _) in allCities.enumerated() {
      if index == Self.userLocationPageControlIndex {
        loadUserLocationDataAsync(dispatchGroup: dispatchGroup)
      } else {
        addContentViewModelAsync(dispatchGroup: dispatchGroup, at: index)
      }
    }

    dispatchGroup.notify(queue: .main) { [weak self] in
      self?.isLoadingData = false
      self?.onSuccess?()
    }
  }

  func loadData(at index: Int) {
    if index == Self.userLocationPageControlIndex {
      loadUserLocationData()
    } else {
      addContentViewModel(at: index)
    }
  }

  func measuringSystemSwitched(_ sender: PMSegmentedControl) {
    ForecastNotificationCenter.post(.unitNotationDidChange,
                                    object: nil,
                                    userInfo: [NotificationCenterUserInfo.segmentedControlChanged.key: sender])
  }

  func showOrHideLocationServicesPrompt(at navigationController: UINavigationController) {
    guard let viewController = navigationController.viewControllers.first else { return }

    let delayInSeconds = 1.0
    DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
      if LocationProvider.shared.isLocationServicesEnabled {
        viewController.navigationItem.prompt = nil

      } else {
        navigationController.viewControllers.first!.navigationItem.prompt = NSLocalizedString("Please enable location services", comment: "")
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds + 3) {
          viewController.navigationItem.prompt = nil
          navigationController.viewIfLoaded?.setNeedsLayout()
        }
      }

      navigationController.viewIfLoaded?.setNeedsLayout()
    }
  }

}

// MARK: - Private - Load data
private extension DefaultForecastViewModel {

  func loadUserLocationData() {
    var successCounterToPreventMultipleExecution = 0

    GeocoderHelper.currentLocation { [weak self] result in
      if successCounterToPreventMultipleExecution >= 1 {
        return
      }

      switch result {
      case .success(let placemark):
        let city = City(placemark: placemark, isUserLocation: true)

        self?.removeUserPreviousLocationContent(by: city)
        self?.insertUserCurrentLocationContent(by: city)
        self?.onSuccess?()
        successCounterToPreventMultipleExecution += 1

      case .failure(let error):
        debugPrint("File: \(#file), Function: \(#function), line: \(#line) \(error)")
        successCounterToPreventMultipleExecution = 1
      }
    }
  }

}

// MARK: - Private - Load data async
private extension DefaultForecastViewModel {

  func loadUserLocationDataAsync(dispatchGroup: DispatchGroup) {
    dispatchGroup.enter()
    var successCounterToPreventMultipleExecution = 0

    GeocoderHelper.currentLocation { [weak self] result in
      guard successCounterToPreventMultipleExecution == 0 else { return }
      defer { dispatchGroup.leave() }

      switch result {
      case .success(let placemark):
        let city = City(placemark: placemark, isUserLocation: true)

        self?.removeUserPreviousLocationContent(by: city)
        self?.insertUserCurrentLocationContent(by: city)
        successCounterToPreventMultipleExecution += 1

      case .failure(let error):
        debugPrint("File: \(#file), Function: \(#function), line: \(#line) \(error)")
        successCounterToPreventMultipleExecution = 1
      }
    }
  }

  func addContentViewModelAsync(dispatchGroup: DispatchGroup, at index: Int) {
    dispatchGroup.enter()
    defer { dispatchGroup.leave() }
    addContentViewModel(at: index)
  }

}

// MARK: - Private -
private extension DefaultForecastViewModel {

  func removeUserPreviousLocationContent(by currentCity: City) {
    let storedCity = cityDataAccessObject.getAllOrderedByIndex()

    var hasStoredCurrentCity: Bool {
      return storedCity.first(where: { $0.compoundKey == currentCity.compoundKey }) != nil
    }

    guard !hasStoredCurrentCity else { return }
    guard let previousCity = storedCity.first(where: { $0.orderIndex == Self.userLocationSortIndex
                                                && $0.isUserLocation == true }) else { return }

    removeContentViewModel(with: LocationDTO(latitude: previousCity.latitude, longitude: previousCity.longitude))
    if let forecast = forecastDataAccessObject.get(latitude: previousCity.latitude,
                                                   longitude: previousCity.longitude) {

      do {
        try forecastDataAccessObject.delete(forecast)
      } catch {
        fatalError("Realm transaction error")
      }
    }
  }

  func insertUserCurrentLocationContent(by city: City) {
    do {
      try cityDataAccessObject.put(city, sortIndex: Self.userLocationSortIndex)
    } catch {
      fatalError("Realm transaction error")
    }

    createAndAddContentViewModel(with: city)
  }

  func createAndAddContentViewModel(with city: City) {
    guard let cityDTO = modelTranslator.translate(city) else { return }
    let contentViewModel = DefaultContentViewModel(city: cityDTO, repository: repository)
    addContentViewModelAtUserLocationPage(viewModel: contentViewModel)
  }

  func addContentViewModelAtUserLocationPage(viewModel: ContentViewModel) {
    guard !checkIfExists(viewModel) else { return }
    contentViewModels.insert(viewModel, at: Self.userLocationPageControlIndex)
  }

  func checkIfExists(_ contentViewModel: ContentViewModel) -> Bool {
    return contentViewModels.contains(where: { return $0.cityName == contentViewModel.cityName })
  }

}
