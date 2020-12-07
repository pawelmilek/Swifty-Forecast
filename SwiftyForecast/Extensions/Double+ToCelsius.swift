extension Double {

  func toCelsius() -> Double {
    let measurement = TemperatureMeasurement(value: self, unit: .fahrenheit)
    let result = measurement.converted(to: .celsius)
    return result
  }

}
