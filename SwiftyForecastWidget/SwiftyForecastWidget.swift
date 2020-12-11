import WidgetKit
import SwiftUI

@main
struct CommitCheckerWidget: Widget {
  private let kind: String = "CommitCheckerWidget"
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: CommitTimeline()) { entry in
      CommitCheckerWidgetView(entry: entry)
    }
    .configurationDisplayName("Swift's Latest Commit")
    .description("Shows the last commit at the Swift repo.")
  }
}

struct PlaceholderView: View {
  var body: some View {
    Text("Loading...")
  }
}

struct CommitCheckerWidgetView: View {
  let entry: LastCommitEntry

  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text("apple/swift's Latest Commit")
        .font(.system(.title3))
        .foregroundColor(.blue)
      Text(entry.commit.message)
        .font(.system(.callout))
        .foregroundColor(.black)
      Text("by \(entry.commit.author) at \(entry.commit.date)")
        .font(.system(.caption))
        .foregroundColor(.black)
      Text("Updated at \(Self.format(date: entry.date))")
        .font(.system(.caption2))
        .foregroundColor(.black)
    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
    .padding()
    .background(LinearGradient(gradient: Gradient(colors: [.orange, .yellow]), startPoint: .top, endPoint: .bottom))
  }

  static func format(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY-MM-dd HH:mm"
    return formatter.string(from: date)
  }
}

struct Commit {
  let message: String
  let author: String
  let date: String
}

struct LastCommitEntry: TimelineEntry {
  let date: Date
  let commit: Commit

  var relevance: TimelineEntryRelevance? {
    return TimelineEntryRelevance(score: 100)
  }
}

struct CommitTimeline: TimelineProvider {
  typealias Entry = LastCommitEntry

  func placeholder(in context: Context) -> Entry {
    let commit = Commit(message: "Fixed stuff", author: "Pawel Milek", date: "2020-12-31")
    let entry = LastCommitEntry(date: Date(), commit: commit)
    return entry
  }

  func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
    let commit = Commit(message: "Fixed stuff", author: "Pawel Milek", date: "2020-12-31")
    let entry = LastCommitEntry(date: Date(), commit: commit)
    completion(entry)
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
    let currentDate = Date()
    let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate) ?? Date()

    CommitLoader.fetch { result in
      let commit: Commit

      switch result {
      case .success(let fetchedCommit):
        commit = fetchedCommit

      case .failure:
        commit = Commit(message: "Failed to load commits", author: "", date: "")
      }

      let entry = LastCommitEntry(date: currentDate, commit: commit)
      let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
      completion(timeline)
    }
  }
}

class CommitLoader {
  static func fetch(completion: @escaping (Result<Commit, Error>) -> Void) {
    let branchContentsURL = URL(string: "https://api.github.com/repos/apple/swift/branches/main")!
    let task = URLSession.shared.dataTask(with: branchContentsURL) { data, _, error in
      guard error == nil else {
        completion(.failure(error!))
        return
      }

      if let data = data, let commit = getCommitInfo(fromData: data) {
        completion(.success(commit))
      } else {
        completion(.failure(NSError(domain: "Failed to get commit info", code: 1234, userInfo: nil)))
      }
    }
    task.resume()
  }

  static func getCommitInfo(fromData data: Data) -> Commit? {
    do {
      guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return nil }
      guard let commitParentJson = json["commit"] as? [String: Any] else { return nil }
      guard let commitJson = commitParentJson["commit"] as? [String: Any] else { return nil }

      let authorJson = commitJson["author"] as? [String: Any]
      let message = commitJson["message"] as? String ?? "Unavailable message"
      let author = authorJson?["name"] as? String ?? "Unavailable name"
      let date = authorJson?["date"] as? String ?? "Unavailable date"
      return Commit(message: message, author: author, date: date)

    } catch {
      fatalError("File: \(#file), Function: \(#function), line: \(#line)")
    }
  }
}

//// MARK: - SwiftyForecastWidget
//struct SwiftyForecastWidget: Widget {
//  let kind = "SwiftyForecastWidget"
//
//  var body: some WidgetConfiguration {
//    StaticConfiguration(kind: kind, provider: Provider()) { entry in
//      SwiftyForecastWidgetEntryView(entry: entry)
//    }
//    .configurationDisplayName("Forecast")
//    .description("Check current conditions and forecast for a location.")
//    .supportedFamilies([.systemSmall])
//  }
//}

// MARK: - Widget Previews
struct SwiftyForecastWidget_Previews: PreviewProvider {
  static var previews: some View {
    let commit = Commit(message: "Fixed stuff", author: "Pawel Milek", date: "2020-12-31")
    let entry = LastCommitEntry(date: Date(), commit: commit)
    CommitCheckerWidgetView(entry: entry)
      .previewContext(WidgetPreviewContext(family: .systemMedium))
  }
}
