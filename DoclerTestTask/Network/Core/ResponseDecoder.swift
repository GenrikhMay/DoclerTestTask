import Foundation

protocol DecoderProtocol {
    func decodeToType<T: Decodable>(data: Data) throws -> T
}
struct ResponseDecoder: DecoderProtocol {
    func decodeToType<T: Decodable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedResponse = try decoder.decode(
            T.self,
            from: data
        )
        return decodedResponse
    }
}
