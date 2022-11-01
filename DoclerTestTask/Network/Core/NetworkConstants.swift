import Foundation

struct NetworkConstants {
    static let baseURL = URL(string: "https://api.themoviedb.org/3")!
    static let apiKey: String = "815b63b537c380370911f6cb083031b0"
    static let defaultParameters: [String: Any] = [
        "api_key": NetworkConstants.apiKey,
        "language": "en-US"
    ]
}
