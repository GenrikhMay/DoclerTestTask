import Foundation

struct MovieViewModel: Decodable {
    var previewPosterPath: String?
    var fullPosterPathURL: String?
    let overview: String
    var genres: String
    let id: Int
    let title: String
    let voteAverage: Double

    init(posterPath: String? = nil, overview: String, genres: String, id: Int, title: String, voteAverage: Double) {
        self.previewPosterPath = posterPath
        self.overview = overview
        self.genres = genres
        self.id = id
        self.title = title
        self.voteAverage = voteAverage
    }

    init(
        movieDTO: MovieDTO,
        genres: [Genre],
        linkBuilder: ImageLinkBuilder = ImageLinkBuilder()
    ) {
        let previewPosterPathURL: String?
        let fullPosterPathURL: String?
        if let posterPath = movieDTO.posterPath {
            previewPosterPathURL = linkBuilder.buildImageLink(fileName: posterPath, size: .preview)
            fullPosterPathURL = linkBuilder.buildImageLink(fileName: posterPath, size: .big)
        } else {
            previewPosterPathURL = nil
            fullPosterPathURL = nil
        }
        let genresString = movieDTO.genreIds.compactMap { genreId in
            genres.first { genre in
                genre.id == genreId
            }?.name.uppercased()
        }.joined(separator: ", ")
        self.previewPosterPath = previewPosterPathURL
        self.fullPosterPathURL = fullPosterPathURL
        self.overview = movieDTO.overview
        self.genres = genresString
        self.id = movieDTO.id
        self.title = movieDTO.title
        self.voteAverage = movieDTO.voteAverage
    }
}
