import Foundation

final class PathFinder {
  static let groupIdentifier = "group.com.pawelmilek.Swifty-Forecast"
  private static let shared = FileManager.default

  static func inLibrary(_ name: String) throws -> URL {
    return try shared
      .url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
      .appendingPathComponent(name)
  }

  static func inDocuments(_ name: String) throws -> URL {
    return try shared
      .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
      .appendingPathComponent(name)
  }

  static func inMainBundle(_ name: String) throws -> URL {
    guard let url = Bundle.main.url(forResource: name, withExtension: nil) else {
      throw PathError.notFound
    }
    return url
  }

  static func inSharedContainer(_ name: String) throws -> URL {
    guard let url = shared.containerURL(forSecurityApplicationGroupIdentifier: PathFinder.groupIdentifier) else {
      throw PathError.containerNotFound(identifier: PathFinder.groupIdentifier)
    }
    return url.appendingPathComponent(name)
  }

  static func documents() throws -> URL {
    return try shared.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
  }
}
