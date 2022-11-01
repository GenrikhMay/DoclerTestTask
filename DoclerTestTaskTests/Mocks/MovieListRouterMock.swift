@testable import DoclerTestTask
import XCTest

final class MovieListRouterMock: MovieListRouterProtocol {
    var openMovieDetailsWasCalled = false

    func openMovieDetails(movie: MovieViewModel) {
        openMovieDetailsWasCalled = true
    }
}
