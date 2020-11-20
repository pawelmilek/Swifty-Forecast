import Foundation

enum PlistFileLoader {
  static func loadFile<T>(with name: String, bundle: Bundle = Bundle.main) throws -> T {
    guard let path = bundle.path(forResource: name, ofType: "plist"),
          let plistXML = FileManager.default.contents(atPath: path) else {
      throw FileLoaderError.fileNotFound(name: name)
    }
    
    if let reslut = try? PropertyListSerialization.propertyList(from: plistXML,
                                                                options: .mutableContainersAndLeaves,
                                                                format: nil) as? T {
      return reslut
    } else {
      throw FileLoaderError.incorrectFormat
    }
  }
  
  static func loadFile<T: Decodable>(with name: String, bundle: Bundle = Bundle.main) throws -> T {
    guard let path = bundle.path(forResource: name, ofType: "plist"),
          let plistXML = FileManager.default.contents(atPath: path) else {
      throw FileLoaderError.fileNotFound(name: name)
    }
    
    if let reslut = try? PropertyListDecoder().decode(T.self, from: plistXML) {
      return reslut
    } else {
      throw FileLoaderError.incorrectFormat
    }
  }
}
