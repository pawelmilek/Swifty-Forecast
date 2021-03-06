protocol ForecastDAO {
  func get(latitude: Double, longitude: Double) -> ForecastResponse?
  func put(data: ForecastResponse)
}
