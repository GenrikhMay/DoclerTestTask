import Foundation

protocol MovieDetailsInteractorProtocol {
    /// Get movie's credits
    /// - Parameters:
    ///   - movieId: movie id
    ///   - completion: callback
    func getCreditsInfo(movieId: Int, completion: @escaping ([CastDTO]) -> Void)
}

final class MovieDetailsInteractor: MovieDetailsInteractorProtocol {
    private let movieNetworkService: MovieNetworkServiceProtocol
    private let configNetworkService: ConfigurationNetworkServiceProtocol

    init(
        movieNetworkService: MovieNetworkServiceProtocol = MovieNetworkService(),
        configNetworkService: ConfigurationNetworkServiceProtocol = ConfigurationNetworkService()
    ) {
        self.movieNetworkService = movieNetworkService
        self.configNetworkService = configNetworkService
    }

    func getCreditsInfo(movieId: Int, completion: @escaping ([CastDTO]) -> Void) {
        movieNetworkService.getMovieCredits(movieId: movieId) { result in
            switch result {
            case .success(let response):
                completion(response.cast)
            case .error:
                completion([])
            }
        }
    }
}
