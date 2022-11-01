import XCTest
@testable import DoclerTestTask

class MovieListInteractorTests: XCTestCase {
    var sut: MovieListInteractor!
    let mockConfigService = StubbedConfigurationNetworkService()
    let mockMovieService = StubbedMovieNetworkService()
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
        sut = MovieListInteractor(
            movieNetworkService: mockMovieService,
            configNetworkService: mockConfigService
        )
    }

    func testSetupConfigSuccessfullyWithTwoPosterSizes() {
        // arrange
        let expectation = self.expectation(description: "config setup exp")

        let expectedBaseUrl = "some/url"
        let expectedSmallerSize = "smallerSize"
        let expectedBiggerSize = "biggerSize"
        let imagesInfo = ConfigurationNetworkResponse.ImagesInfo(
            baseUrl: "",
            secureBaseUrl: expectedBaseUrl,
            backdropSizes: [],
            logoSizes: [],
            posterSizes: [expectedSmallerSize, expectedBiggerSize],
            profileSizes: [],
            stillSizes: []
        )
        let configResponse = ConfigurationNetworkResponse(
            images: imagesInfo,
            changeKeys: []
        )
        mockConfigService.getConfigurationStub = .success(configResponse)

        // act
        sut.setupConfig {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 0.5)

        // assert
        XCTAssertEqual(MovieApiConfiguration.shared.properties[.imageBaseURL], expectedBaseUrl)
        XCTAssertEqual(MovieApiConfiguration.shared.properties[.previewPosterSize], expectedSmallerSize)
        XCTAssertEqual(MovieApiConfiguration.shared.properties[.fullPosterSize], expectedBiggerSize)
    }

    func testSetupConfigSuccessfullyWithOnePosterSize() {
        // arrange
        let expectation = self.expectation(description: "config setup exp")

        let expectedBaseUrl = "some/url"
        let expectedSmallerSize = "smallerSize"
        let imagesInfo = ConfigurationNetworkResponse.ImagesInfo(
            baseUrl: "",
            secureBaseUrl: expectedBaseUrl,
            backdropSizes: [],
            logoSizes: [],
            posterSizes: [expectedSmallerSize],
            profileSizes: [],
            stillSizes: []
        )
        let configResponse = ConfigurationNetworkResponse(
            images: imagesInfo,
            changeKeys: []
        )
        mockConfigService.getConfigurationStub = .success(configResponse)

        // act
        sut.setupConfig {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 0.5)

        // assert
        XCTAssertEqual(MovieApiConfiguration.shared.properties[.imageBaseURL], expectedBaseUrl)
        XCTAssertEqual(MovieApiConfiguration.shared.properties[.previewPosterSize], expectedSmallerSize)
        XCTAssertEqual(MovieApiConfiguration.shared.properties[.fullPosterSize], expectedSmallerSize)
    }

    func testSetupConfigSuccessfullyWithNoPosterSizes() {
        // arrange
        let expectation = self.expectation(description: "config setup exp")

        let imagesInfo = ConfigurationNetworkResponse.ImagesInfo(
            baseUrl: "",
            secureBaseUrl: nil,
            backdropSizes: [],
            logoSizes: [],
            posterSizes: [],
            profileSizes: [],
            stillSizes: []
        )
        let configResponse = ConfigurationNetworkResponse(
            images: imagesInfo,
            changeKeys: []
        )
        mockConfigService.getConfigurationStub = .success(configResponse)

        // act
        sut.setupConfig {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 0.5)

        // assert
        XCTAssertNil(MovieApiConfiguration.shared.properties[.imageBaseURL])
        XCTAssertNil(MovieApiConfiguration.shared.properties[.previewPosterSize])
        XCTAssertNil(MovieApiConfiguration.shared.properties[.fullPosterSize])
    }

    func testFetchTopMoviesSucceeded() {
        // arrange
        let expectation = self.expectation(description: "fetch movies exp")

        let mockResponse = MoviesListResponse(
            page: 1,
            results: [],
            totalResults: 0,
            totalPages: 1
        )
        mockMovieService.getPopularMoviesStub = .success(mockResponse)
        let presenterMock = MovieListPresenterMock()
        presenterMock.expectation = expectation
        sut.delegate = presenterMock

        // act
        sut.fetchTopMovies(page: 1)

        // assert
        waitForExpectations(timeout: 0.5)
        XCTAssertTrue(presenterMock.addToMovieListWasCalled)
    }

    func testFetchGenresSucceeded() {
        // arrange
        let expectation = self.expectation(description: "fetch genres exp")
        var fetchedGenres: [Genre] = []

        let predefinedGenres = [
            Genre(id: 1, name: "genre1"),
            Genre(id: 2, name: "genre2")
        ]
        let mockResponse = GenresNetworkResponse(genres: predefinedGenres)
        mockMovieService.getGenresStub = .success(mockResponse)
        let presenterMock = MovieListPresenterMock()
        presenterMock.expectation = expectation
        sut.delegate = presenterMock

        // act
        sut.fetchGenres { genres in
            fetchedGenres = genres
            expectation.fulfill()
        }

        // assert
        waitForExpectations(timeout: 0.5)
        XCTAssertEqual(fetchedGenres, predefinedGenres)
    }

    func testFetchGenresFailed() {
        // arrange
        let expectation = self.expectation(description: "fetch genres exp")
        var fetchedGenres: [Genre]!

        mockMovieService.getGenresStub = .error(.requestMapping("test error"))
        let presenterMock = MovieListPresenterMock()
        presenterMock.expectation = expectation
        sut.delegate = presenterMock

        // act
        sut.fetchGenres { genres in
            fetchedGenres = genres
            expectation.fulfill()
        }

        // assert
        waitForExpectations(timeout: 0.5)
        XCTAssertTrue(fetchedGenres.isEmpty)
    }

    func testSearchMovieSuccessFirstPage() {
        // arrange
        let expectation = self.expectation(description: "search movie exp")
        let response = MoviesListResponse(
            page: 1,
            results: [sampleMovie],
            totalResults: 1,
            totalPages: 1
        )

        mockMovieService.searchMovieStub = .success(response)
        let presenterMock = MovieListPresenterMock()
        presenterMock.expectation = expectation
        sut.delegate = presenterMock

        // act
        sut.searchMovie(query: "", page: 1)
        // assert
        waitForExpectations(timeout: 0.5)
        XCTAssertTrue(presenterMock.updateSearchResultsWasCalled)
        XCTAssertFalse(presenterMock.addToMovieListWasCalled)
    }

    func testSearchMovieSuccessNonFirstPage() {
        // arrange
        let expectation = self.expectation(description: "search movie exp")

        let response = MoviesListResponse(
            page: 2,
            results: [sampleMovie],
            totalResults: 20,
            totalPages: 2
        )

        mockMovieService.searchMovieStub = .success(response)
        let presenterMock = MovieListPresenterMock()
        presenterMock.expectation = expectation
        sut.delegate = presenterMock

        // act
        sut.searchMovie(query: "", page: 2)
        // assert
        waitForExpectations(timeout: 0.5)
        XCTAssertFalse(presenterMock.updateSearchResultsWasCalled)
        XCTAssertTrue(presenterMock.addToMovieListWasCalled)
    }

    func testSearchMovieFailed() {
        // arrange
        let expectation = self.expectation(description: "search movie exp")

        let response = MoviesListResponse(
            page: 1,
            results: [sampleMovie],
            totalResults: 1,
            totalPages: 1
        )

        mockMovieService.searchMovieStub = .success(response)
        let presenterMock = MovieListPresenterMock()
        presenterMock.expectation = expectation
        sut.delegate = presenterMock

        // act
        sut.searchMovie(query: "", page: 1)
        // assert
        waitForExpectations(timeout: 0.5)
        XCTAssertTrue(presenterMock.updateSearchResultsWasCalled)
        XCTAssertFalse(presenterMock.addToMovieListWasCalled)
    }
}
