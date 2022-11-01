@testable import DoclerTestTask
import XCTest

final class MovieListInteractorMock: MovieListInteractorProtocol {
    var expectation: XCTestExpectation?

    var setupConfigWasCalled = false
    var fetchTopMoviesWasCalled = false
    var fetchGenresWasCalled = false
    var searchMovieWasCalled = false

    var fetchTopMoviesStub: (() -> Void)!
    var searchMovieStub: (() -> Void)!

    var fetchGenresStub: [Genre]!

    func setupConfig(completion: @escaping () -> Void) {
        setupConfigWasCalled = true
        completion()
        expectation?.fulfill()
    }

    func fetchTopMovies(page: Int) {
        fetchTopMoviesWasCalled = true
    }

    func fetchGenres(completion: @escaping ([Genre]) -> Void) {
        fetchGenresWasCalled = true
        completion(fetchGenresStub)
        expectation?.fulfill()
    }

    func searchMovie(query: String, page: Int) {
        searchMovieWasCalled = true
        searchMovieStub?()
    }
}
