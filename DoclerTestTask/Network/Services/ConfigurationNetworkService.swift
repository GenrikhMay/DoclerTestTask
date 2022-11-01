import Foundation
import Moya

protocol ConfigurationNetworkServiceProtocol {
    /// Get basic API configuartion
    /// - Parameter completion: callback
    func getConfiguration(completion: @escaping (Result<ConfigurationNetworkResponse>) -> Void)
}

final class ConfigurationNetworkService: ConfigurationNetworkServiceProtocol {
    let networkService: NetworkService<ConfigurationAPIEndpoints>

    init(provider: MoyaProvider<ConfigurationAPIEndpoints> = MoyaProvider<ConfigurationAPIEndpoints>()) {
        self.networkService = NetworkService(provider: provider)
    }

    func getConfiguration(completion: @escaping (Result<ConfigurationNetworkResponse>) -> Void) {
        networkService.request(.getConfiguration) { result in
            completion(result)
        }
    }
}
