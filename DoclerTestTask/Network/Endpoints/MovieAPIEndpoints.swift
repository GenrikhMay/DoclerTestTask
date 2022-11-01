import Foundation
import Moya

enum MovieAPIEndpoints {
    case getTopMovies(page: Int)
    case getGenres
    case searchMovie(query: String, page: Int)
    case credits(movieId: Int)
}

extension MovieAPIEndpoints: TargetType {
    var baseURL: URL {
        NetworkConstants.baseURL
    }

    var path: String {
        switch self {
        case .getTopMovies:
            return "/movie/popular"
        case .getGenres:
            return "/genre/movie/list"
        case .searchMovie:
            return "/search/movie"
        case .credits(let movieId):
            return "/movie/\(movieId)/credits"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getTopMovies, .getGenres, .searchMovie, .credits:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .getTopMovies(let page):
            var parameters = NetworkConstants.defaultParameters
            parameters["page"] = page
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
        case .getGenres, .credits:
            return .requestParameters(
                parameters: NetworkConstants.defaultParameters,
                encoding: URLEncoding.queryString
            )
        case let .searchMovie(query, page):
            var parameters = NetworkConstants.defaultParameters
            parameters["query"] = query
            parameters["page"] = page
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
        }
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
