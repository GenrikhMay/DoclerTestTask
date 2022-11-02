@testable import DoclerTestTask
import XCTest

final class MovieListPresenterMock: MovieListPresenterProtocol, MovieListInteractorDelegate {
    var movieList: [MovieViewModel] = []
    var expectation: XCTestExpectation?

    var setupViewWasCalled = false
    var loadMoviesIfNeededWasCalled = false
    var searchQueryChangedWasCalled = false
    var movieWasTappedWasCalled = false
    var addToMovieListWasCalled = false
    var updateSearchResultsWasCalled = false

    func viewDidLoad() {
        setupViewWasCalled = true
    }

    func willDisplayCell(at index: Int) {
        loadMoviesIfNeededWasCalled = true
        expectation?.fulfill()
    }

    func searchQueryChanged(query: String) {
        searchQueryChangedWasCalled = true
        expectation?.fulfill()
    }

    func tableViewCellWasTapped(at index: Int) {
        movieWasTappedWasCalled = true
        expectation?.fulfill()
    }

    func addToMovieList(movies: [MovieDTO]) {
        addToMovieListWasCalled = true
        expectation?.fulfill()
    }

    func updateSearchResults(movies: [MovieDTO]) {
        updateSearchResultsWasCalled = true
        expectation?.fulfill()
    }
}
