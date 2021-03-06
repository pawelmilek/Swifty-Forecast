import UIKit
import CoreLocation
import RealmSwift

final class CityListSelectionViewController: UIViewController {
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var searchLocationButton: UIButton!
  
  weak var coordinator: MainCoordinator?
  weak var delegate: CityListSelectionViewControllerDelegate?
  var viewModel: CityListViewModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUp()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  deinit {
    debugPrint("File: \(#file), Function: \(#function), line: \(#line) deinit CityListSelectionTableViewController")
    viewModel?.onViewDeinit()
  }
}

// MARK: - Private - SetUps
private extension CityListSelectionViewController {
  
  func setUp() {
    setTableView()
    setSearchLocationButton()
    relaodData()
    
    viewModel?.onCitySelected = { [weak self] index in
      guard let self = self else { return }
      self.delegate?.cityListSelection(self, didSelect: index)
    }
    
    viewModel?.onInitialDataLoad = { [weak self] in
      self?.tableView.reloadData()
    }
    
    viewModel?.onApplyListChanges = { [weak self] deletions, insertions, updates in
      self?.tableView.applyChanges(deletions: deletions, insertions: insertions, updates: updates)
    }
  }
  
  private func relaodData() {
    tableView.reloadData()
  }
  
}

// MARK: - Private - Setters
private extension CityListSelectionViewController {
  
  func setTableView() {
    tableView.register(cellClass: CityTableViewCell.self)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.isUserInteractionEnabled = true
    tableView.allowsMultipleSelectionDuringEditing = false
    tableView.tableFooterView = UIView()
    tableView.backgroundColor = Style.CityList.backgroundColor
    tableView.separatorStyle = Style.CityList.separatorStyle
    tableView.separatorColor = Style.CityList.separatorColor
    tableView.separatorInset = Style.CityList.separatorInset
  }
  
  func setSearchLocationButton() {
    searchLocationButton.layer.cornerRadius = 15
    searchLocationButton.clipsToBounds = true
    searchLocationButton.setTitle("Search Location", for: .normal)
    searchLocationButton.backgroundColor = Style.CityList.searchLocationButtonBackgroundColor
    searchLocationButton.addTarget(self, action: #selector(searchLocationButtonTapped(_:)), for: .touchUpInside)
  }
  
}


// MARK: - UITableViewDataSource protocol
extension CityListSelectionViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel?.numberOfCities ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let viewModel = viewModel else { return UITableViewCell() }
    let cell = tableView.dequeueCell(CityTableViewCell.self, for: indexPath)
    let row = indexPath.row
    let cityName = viewModel.name(at: row)
    let localTime = viewModel.localTime(at: row)
    let map = viewModel.map(at: row)
    
    cell.tag = row
    cell.configure(by: cityName, time: localTime, annotation: map?.annotation, region: map?.region)
    
    let cityCellViewModel = viewModel.cityCellViewModel(at: row)
    let token = cityCellViewModel?.loadTimeZone { result in
      if case .success = result {
        DispatchQueue.main.async {
          cell.configure(time: viewModel.localTime(at: row))
        }
      }
    }
    
    cell.onReuse = {
      if let token = token {
        cityCellViewModel?.cancelLoad(token)
      }
    }
    
    return cell
  }
  
}

// MARK: - UITableViewDelegate protocol
extension CityListSelectionViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel?.select(at: indexPath.row)
    coordinator?.onSelectCityFromAvailableCollection()
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return indexPath.row == 0 ? false : true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else { return }
    viewModel?.delete(at: indexPath)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return CityTableViewCell.defaultHeight
  }
  
}

// MARK: - Private - Actions
private extension CityListSelectionViewController {
  
  @objc func searchLocationButtonTapped(_ sender: UIButton) {
    coordinator?.onSearchLocation()
  }
  
}

// MARK: - Factory method
extension CityListSelectionViewController {
  
  static func make() -> CityListSelectionViewController {
    return StoryboardViewControllerFactory.make(CityListSelectionViewController.self, from: .main)
  }
  
}
