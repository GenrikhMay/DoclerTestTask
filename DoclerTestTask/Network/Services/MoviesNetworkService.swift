import Foundation
import Moya

protocol MovieNetworkServiceProtocol {
    /// Get top popular movies
    /// - Parameters:
    ///   - page: Number of desired page
    ///   - completion: callback
    func getPopularMovies(page: Int, completion: @escaping (Result<MoviesTopPopularResponse>) -> Void)

    /// Get array of genres with their IDs
    /// - Parameter completion: callback
    func getGenres(completion: @escaping (Result<GenresNetworkResponse>) -> Void)

    /// Search movie
    /// - Parameters:
    ///   - query: search query
    ///   - page: Number of desired page
    ///   - completion: callback
    func searchMovie(
        query: String,
        page: Int,
        completion: @escaping (Result<MoviesTopPopularResponse>) -> Void
    )

    /// Get cast and crew info
    /// - Parameters:
    ///   - movieId: movie id
    ///   - completion: callback
    func getMovieCredits(
        movieId: Int,
        completion: @escaping (Result<CreditsNetworkResponse>) -> Void
    )
}

final class MovieNetworkService: MovieNetworkServiceProtocol {
    let networkService: NetworkService<MovieAPIEndpoints>

    init(provider: MoyaProvider<MovieAPIEndpoints> = MoyaProvider<MovieAPIEndpoints>()) {
        self.networkService = NetworkService(provider: provider)
    }

    func getPopularMovies(page: Int, completion: @escaping (Result<MoviesTopPopularResponse>) -> Void) {
        networkService.request(.getTopMovies(page: page)) { result in
            completion(result)
        }
    }

    func getGenres(completion: @escaping (Result<GenresNetworkResponse>) -> Void) {
        networkService.request(.getGenres) { result in
            completion(result)
        }
    }

    func searchMovie(
        query: String,
        page: Int,
        completion: @escaping (Result<MoviesTopPopularResponse>) -> Void
    ) {
        networkService.request(.searchMovie(query: query, page: page)) { result in
            completion(result)
        }
    }

    func getMovieCredits(
        movieId: Int,
        completion: @escaping (Result<CreditsNetworkResponse>) -> Void
    ) {
        networkService.request(.credits(movieId: movieId)) { result in
            completion(result)
        }
    }
}
