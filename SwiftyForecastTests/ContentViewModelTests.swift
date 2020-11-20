import XCTest
@testable import SwiftyForecast

class ContentViewModelTests: XCTestCase {
  private var sut: ContentViewModel!
  private var httpClient: HttpClient<ForecastResponse>!
  private var testService: TestForecastService!
  private var repository: Repository!
  private var notationController: NotationController!
  
  override func setUp() {
    super.setUp()
    
    let defaultsName = "NotationControllerTests"
    let userDefaults = UserDefaults(suiteName: defaultsName)!
    userDefaults.removePersistentDomain(forName: defaultsName)
    notationController = NotationController(storage: userDefaults)

    httpClient = HttpClient(session: URLSessionMock())
    testService = TestForecastService(httpClient: httpClient, request: TestForecastWebRequest())
    testService.successCompletion = .success(MockGenerator.generateForecast()!)
    
    repository = TestRepository(service: testService, dataAccessObject: TestForecastDAO())
    sut = DefaultContentViewModel(city: MockGenerator.generateCityDTO(),
                                  repository: repository,
                                  notationController: notationController)
  }
  
  override func tearDown() {
    super.tearDown()
    
    httpClient = nil
    testService = nil
    repository = nil
    sut = nil
  }
  
  func testLoadData_returnsSuccess() {
    var isSuccess = false
    
    sut.onSuccess = {
      isSuccess = true
    }
    
    sut.loadData()
    XCTAssertTrue(isSuccess, "Unable to load content data successfully")
  }
  
  func testNumberOfHours_24Hours() {
    sut.loadData()
    
    let numberOfHours = sut.hourly!.data.count
    let expected = 24
    XCTAssertEqual(expected, numberOfHours)
  }

  func testLastHourDate_gets20190428() {
    sut.loadData()
    
    let data = sut.hourly!.data.last!
    let expected = data.date
    XCTAssertEqual("\(expected)", "2019-04-28 19:00:00 +0000")
  }
  
  func testLastHourSummary_getsClear() {
    sut.loadData()
    
    let data = sut.hourly!.data.last!
    let expected = data.summary
    
    XCTAssertEqual(expected, "Clear")
  }
  
  func testLastHourIconName_getsClearDayIcon() {
    sut.loadData()
    
    let data = sut.hourly!.data.last!
    let expected = data.icon

    XCTAssertEqual(expected, "clear-day")
  }
  
  func testLastHourTemperature_getsInFahrenheit() {
    sut.loadData()
    
    let data = sut.hourly!.data.last!
    let expected = data.temperature

    XCTAssertEqual(expected, 46.67)
  }
  
  func testCurrentlyConditionIcon_setSnowIcon_getsAttributedStringIcon() {
    sut.loadData()
    
    let forecast = MockGenerator.generateForecast()!
    let icon = forecast.currently!.icon
    let font = Style.CurrentForecast.conditionFontIconSize
    let expected = ConditionFontIcon.make(icon: icon, font: font)?.attributedIcon
    
    XCTAssertEqual(expected, sut.icon)
  }
  
  func testWeekdayMonthDay_SaturdayApril27() {
    sut.loadData()
    let expected = "SATURDAY, APRIL 27"
    XCTAssertEqual(expected, sut.weekdayMonthDay)
  }
  
  func testCityName_getsCupertino() {
    sut.loadData()
    let expected = "Cupertino"
    
    XCTAssertEqual(expected, sut.cityName)
  }
  
  func testTemperature_setCelsiusTempNotation_gets1Celsius() {
    sut.loadData()
    notationController.temperatureNotation = .celsius
    let expected = "1°"
    
    XCTAssertEqual(expected, sut.temperature)
  }
  
  func testTemperature_setFahrenheitTempNotation_gets34Fahrenheit() {
    sut.loadData()
    notationController.temperatureNotation = .fahrenheit
    let expected = "34°"
    
    XCTAssertEqual(expected, sut.temperature)
  }
  
  func testHumidity_gets96() {
    sut.loadData()
    let expected = "96"
    
    XCTAssertEqual(expected, sut.humidity)
  }
  
  func testSunriseTime_gets553AM() {
    sut.loadData()
    let expected = "5:53 AM"
    
    XCTAssertEqual(expected, sut.sunriseTime)
  }
  
  func testSunsetTime_gets745PM() {
    sut.loadData()
    let expected = "7:45 PM"
    
    XCTAssertEqual(expected, sut.sunsetTime)
  }
  
  func testWindSpeed_setImperialUnitNotation_gets13MPH() {
    sut.loadData()
    notationController.unitNotation = .imperial
    let expected = "13 MPH"
    
    XCTAssertEqual(expected, sut.windSpeed)
  }
  
  func testWindSpeed_setMetricUnitNotation_gets20KPH() {
    sut.loadData()
    notationController.unitNotation = .metric
    let expected = "20 KPH"
    
    XCTAssertEqual(expected, sut.windSpeed)
  }
  
  func testNumberOfDays_getsSevenDays() {
    sut.loadData()
    let expected = 7
    
    XCTAssertEqual(expected, sut.numberOfDays)
  }
  
  func testSevenDaysDataCount_getsSevenElements() {
    sut.loadData()
    let expected = 7
    
    XCTAssertEqual(expected, sut.sevenDaysData.count)
  }
}
