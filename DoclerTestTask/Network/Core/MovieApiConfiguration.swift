import Foundation

final class MovieApiConfiguration {
    private(set) var properties: [ConfigKey: String] = [:]

    static let shared = MovieApiConfiguration()
    private init() {}

    func addValue(key: ConfigKey, value: String) {
        properties[key] = value
    }
}

enum ConfigKey: String {
    case imageBaseURL
    case previewPosterSize
    case fullPosterSize
}
