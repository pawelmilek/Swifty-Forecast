extension Int {
  // swiftlint:disable large_tuple
  var convertToHoursMinutesSeconds: (hours: Int, minutes: Int, seconds: Int) {
    return (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
  }

}
