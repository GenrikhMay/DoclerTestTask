struct CreditsNetworkResponse: Decodable {
    let id: Int?
    let cast: [CastDTO]
    let crew: [CrewDTO]
}
