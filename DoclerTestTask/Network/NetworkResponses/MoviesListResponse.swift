struct MoviesListResponse: Decodable {
    let page: Int
    let results: [MovieDTO]
    let totalResults: Int
    let totalPages: Int
}
