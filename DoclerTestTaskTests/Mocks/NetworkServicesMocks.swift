import XCTest
@testable import DoclerTestTask

final class StubbedConfigurationNetworkService: ConfigurationNetworkServiceProtocol {
    var getConfigurationStub: Result<ConfigurationNetworkResponse>!

    func getConfiguration(completion: @escaping (Result<ConfigurationNetworkResponse>) -> Void) {
        completion(getConfigurationStub)
    }
}

final class StubbedMovieNetworkService: MovieNetworkServiceProtocol {
    var getPopularMoviesStub: Result<MoviesListResponse>!
    var getGenresStub: Result<GenresNetworkResponse>!
    var searchMovieStub: Result<MoviesListResponse>!
    var getMovieCreditsStub: Result<CreditsNetworkResponse>!

    func getPopularMovies(page: Int, completion: @escaping (Result<MoviesListResponse>) -> Void) {
        completion(getPopularMoviesStub)
    }

    func getGenres(completion: @escaping (Result<GenresNetworkResponse>) -> Void) {
        completion(getGenresStub)
    }

    func searchMovie(query: String, page: Int, completion: @escaping (Result<MoviesListResponse>) -> Void) {
        completion(searchMovieStub)
    }

    func getMovieCredits(movieId: Int, completion: @escaping (Result<CreditsNetworkResponse>) -> Void) {
        completion(getMovieCreditsStub)
    }
}
