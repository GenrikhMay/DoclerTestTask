struct ConfigurationNetworkResponse: Decodable {
    struct ImagesInfo: Decodable {
        let baseUrl: String
        let secureBaseUrl: String?
        let backdropSizes: [String]
        let logoSizes: [String]
        let posterSizes: [String]
        let profileSizes: [String]
        let stillSizes: [String]
    }

    let images: ImagesInfo
    let changeKeys: [String]
}
