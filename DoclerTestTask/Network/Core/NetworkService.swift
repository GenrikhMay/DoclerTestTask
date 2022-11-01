import Foundation
import Moya

enum Result<T> {
    case success(T)
    case error(MoyaError)
}

/// General Network requests executor
 final class NetworkService<T: TargetType> {
    let provider: MoyaProvider<T>
    let decoder: DecoderProtocol

    init(
        provider: MoyaProvider<T>,
        decoder: DecoderProtocol = ResponseDecoder()
    ) {
        self.provider = provider
        self.decoder = decoder
    }

     /// Execute network request
     /// - Parameters:
     ///   - target: request target destination
     ///   - completion: callback
    func request<ResponseType: Decodable>(
        _ target: T,
        completion: @escaping (Result<ResponseType>) -> Void
    ) {
        provider.request(target) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    guard let self = self else {
                        completion(.error(.jsonMapping(response)))
                        return
                    }
                    let decodedResponse: ResponseType = try self.decoder.decodeToType(data: response.data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.error(MoyaError.jsonMapping(response)))
                }
            case .failure(let error):
                completion(.error(error))
            }
        }
    }
 }
