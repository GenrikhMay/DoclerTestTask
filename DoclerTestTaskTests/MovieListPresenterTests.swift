import XCTest
@testable import DoclerTestTask

class MovieListPresenterTests: XCTestCase {
    var sut: MovieListPresenter!
    var router: MovieListRouterMock!
    var interactor: MovieListInteractorMock!
    var view: MovieListViewMock!

    let sampleMovie = MovieDTO(
        posterPath: nil,
        adult: true,
        overview: "",
        releaseDate: nil,
        genreIds: [],
        id: 1,
        originalTitle: "",
        originalLanguage: "",
        title: "",
        backdropPath: nil,
        popularity: 5.0,
        voteCount: 4,
        video: false,
        voteAverage: 8.0
    )

    override func setUpWithError() throws {
        interactor = MovieListInteractorMock()
        view = MovieListViewMock()
        router = MovieListRouterMock()
        sut = MovieListPresenter()
        sut.interactor = interactor
        sut.router = router
        sut.view = view
    }

    func testSetupView() {
        // arrange
        let expectation = expectation(description: "movieListPresenter exp")
        expectation.expectedFulfillmentCount = 2
        let genres = [
            Genre(id: 1, name: "name")
        ]
        interactor.expectation = expectation
        interactor.fetchGenresStub = genres
        interactor.fetchTopMoviesStub = {}

        // act
        sut.setupView()

        // assert
        waitForExpectations(timeout: 0.5)
        XCTAssertTrue(interactor.setupConfigWasCalled)
        XCTAssertTrue(interactor.fetchGenresWasCalled)
        XCTAssertTrue(interactor.fetchTopMoviesWasCalled)
    }

    func testLoadMoviesIfNeededBeforeTresholdEmptySearch() {
        // arrange
        let loadedMovies: [MovieDTO] = Array(repeating: sampleMovie, count: 20)
        sut.addToMovieList(movies: loadedMovies)

        // act
        sut.loadMoviesIfNeeded(displayedMovieIndex: 10)

        // assert
        XCTAssertFalse(interactor.fetchTopMoviesWasCalled)
    }

    func testLoadMoviesIfNeededMoreThanTresholdEmptySearch() {
        // arrange
        let loadedMovies: [MovieDTO] = Array(repeating: sampleMovie, count: 20)
        sut.addToMovieList(movies: loadedMovies)

        // act
        sut.loadMoviesIfNeeded(displayedMovieIndex: 18)

        // assert
        XCTAssertTrue(interactor.fetchTopMoviesWasCalled)
    }

    func testLoadMoviesIfNeededBeforeTresholdNonEmptySearch() {
        // arrange
        let loadedMovies: [MovieDTO] = Array(repeating: sampleMovie, count: 20)
        sut.searchQueryChanged(query: "query")
        sut.addToMovieList(movies: loadedMovies)

        // act
        sut.loadMoviesIfNeeded(displayedMovieIndex: 10)

        // assert
        XCTAssertFalse(interactor.fetchTopMoviesWasCalled)
    }

    func testLoadMoviesIfNeededMoreThanTresholdNonEmptySearch() {
        // arrange
        let loadedMovies: [MovieDTO] = Array(repeating: sampleMovie, count: 20)
        sut.searchQueryChanged(query: "query")
        sut.addToMovieList(movies: loadedMovies)
        interactor.searchMovieStub = {}

        // act
        sut.loadMoviesIfNeeded(displayedMovieIndex: 18)

        // assert
        XCTAssertTrue(interactor.searchMovieWasCalled)
    }

    func testsearchQueryChangedToEmpty() {
        // arrange
        sut.addToMovieList(movies: [sampleMovie])

        // act
        sut.searchQueryChanged(query: "")

        // assert
        XCTAssertTrue(sut.movieList.isEmpty)
        XCTAssertTrue(interactor.fetchTopMoviesWasCalled)
    }

    func testsearchQueryChangedToNonEmpty() {
        // arrange
        let expectation = expectation(description: "movieListPresenter exp")
        interactor.searchMovieStub = {
            expectation.fulfill()
        }

        // act
        sut.searchQueryChanged(query: "query")

        // assert
        waitForExpectations(timeout: 0.5)
        XCTAssertTrue(interactor.searchMovieWasCalled)
    }

    func testMovieWasTappedIndexWithinBorders() {
        // arrange
        sut.addToMovieList(movies: Array(repeating: sampleMovie, count: 5))

        // act
        sut.movieWasTapped(index: 2)

        // assert
        XCTAssertTrue(router.openMovieDetailsWasCalled)
    }

    func testMovieWasTappedWrongIndex() {
        // arrange
        sut.addToMovieList(movies: Array(repeating: sampleMovie, count: 5))

        // act
        sut.movieWasTapped(index: 10)

        // assert
        XCTAssertFalse(router.openMovieDetailsWasCalled)
    }

    func testAddToMovieList() {
        sut.addToMovieList(movies: Array(repeating: sampleMovie, count: 5))
        XCTAssertEqual(sut.movieList.count, 5)

        sut.addToMovieList(movies: Array(repeating: sampleMovie, count: 5))
        XCTAssertEqual(sut.movieList.count, 10)

        // assert
        XCTAssertTrue(view.updateMovieListWasCalled)
    }

    func testUpdateSerchResultsEmptyQuery() {
        // arrange
        sut.searchQueryChanged(query: "")

        // act
        sut.updateSearchResults(movies: [])

        // assert
        XCTAssertFalse(view.updateMovieListWasCalled)
    }

    func testUpdateSerchResultsNonEmptyQuery() {
        // arrange
        let expectation = expectation(description: "movieListPresenter exp")
        expectation.expectedFulfillmentCount = 2
        view.updateMovieListStub = {
            expectation.fulfill()
        }
        sut.searchQueryChanged(query: "query")
        sut.addToMovieList(movies: Array(repeating: sampleMovie, count: 10))

        // act
        sut.updateSearchResults(movies: [sampleMovie])

        // assert
        waitForExpectations(timeout: 0.5)
        XCTAssertTrue(view.updateMovieListWasCalled)
        XCTAssertEqual(sut.movieList.count, 1)
    }
}
