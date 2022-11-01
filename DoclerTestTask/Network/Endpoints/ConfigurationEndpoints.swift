import Foundation
import Moya

enum ConfigurationAPIEndpoints {
    case getConfiguration
}

extension ConfigurationAPIEndpoints: TargetType {
    var baseURL: URL {
        NetworkConstants.baseURL
    }

    var path: String {
        switch self {
        case .getConfiguration:
            return "/configuration"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getConfiguration:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .getConfiguration:
            return .requestParameters(
                parameters: NetworkConstants.defaultParameters,
                encoding: URLEncoding.queryString
            )
        }
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
