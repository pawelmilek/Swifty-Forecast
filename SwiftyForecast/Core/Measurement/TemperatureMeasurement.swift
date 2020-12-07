import Foundation

// swiftlint:disable identifier_name
struct TemperatureMeasurement {
  private let measurement: Measurement<UnitTemperature>

  init(value: Double, unit: UnitTemperature) {
    measurement = Measurement(value: value, unit: unit)
  }

  func converted(to: UnitTemperature) -> Double {
    let result = measurement.converted(to: to)
    return result.value
  }
}
