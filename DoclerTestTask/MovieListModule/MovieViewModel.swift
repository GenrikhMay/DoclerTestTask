import Foundation

struct MovieViewModel: Decodable {
    let id: Int
    let overview: String
    var genres: String
    let title: String
    let voteAverage: Double
    var previewPosterPath: String?
    var fullPosterPath: String?

    init(
        id: Int,
        overview: String,
        genres: String,
        title: String,
        voteAverage: Double,
        previewPosterPath: String? = nil,
        fullPosterPath: String? = nil
    ) {
        self.overview = overview
        self.genres = genres
        self.id = id
        self.title = title
        self.voteAverage = voteAverage
        self.previewPosterPath = previewPosterPath
        self.fullPosterPath = fullPosterPath
    }

    init(
        movieDTO: MovieDTO,
        genres: [GenreViewModel],
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
        self.fullPosterPath = fullPosterPathURL
        self.overview = movieDTO.overview
        self.genres = genresString
        self.id = movieDTO.id
        self.title = movieDTO.title
        self.voteAverage = movieDTO.voteAverage
    }
}
