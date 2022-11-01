import Foundation
import UIKit

protocol MovieListPresenterProtocol: AnyObject {
    var movieList: [MovieViewModel] { get }

    /// Load initial info and set it up
    func setupView()

    /// Load more movies if end of list movie list was shown
    /// - Parameter displayedMovieIndex: displayed movie index
    func loadMoviesIfNeeded(displayedMovieIndex: Int)

    /// Update movie list according to search query
    /// - Parameter query: search query
    func searchQueryChanged(query: String)

    /// Process tapping on exact movie
    /// - Parameter index: chosen movie index
    func movieWasTapped(index: Int)
}

protocol MovieListInteractorDelegate: AnyObject {
    /// Add movies to movie list
    /// - Parameter movies: movies to add
    func addToMovieList(movies: [MovieDTO])

    /// Update search results
    /// - Parameter movies: search result array
    func updateSearchResults(movies: [MovieDTO])
}

final class MovieListPresenter: MovieListPresenterProtocol {
    var interactor: MovieListInteractorProtocol?
    var router: MovieListRouterProtocol?
    weak var view: MovieListViewProtocol?

    private(set) var movieList: [MovieViewModel] = []
    private let loadMoreTreshold: Int = 5
    private let numberOfMoviesPerPage: Int = 20
    private let maxMovies: Int = 100
    private var genres: [GenreDTO]?
    private var searchTimer: Timer?
    private let searchDebounceTime: Double = 0.5
    private var isLoading: Bool = false
    private var searchQuery: String = ""

    func setupView() {
        interactor?.configSetup { [weak self] in
            self?.interactor?.fetchGenres { [weak self] genres in
                self?.genres = genres
                self?.interactor?.fetchTopMovies(page: 1)
            }
        }
        isLoading = true
    }

    func loadMoviesIfNeeded(displayedMovieIndex: Int) {
        guard !isLoading else { return }
        if searchQuery.isEmpty {
            guard movieList.count < maxMovies else { return }
            if displayedMovieIndex >= (movieList.count - loadMoreTreshold) {
                isLoading = true
                interactor?.fetchTopMovies(page: (movieList.count / numberOfMoviesPerPage + 1))
            }
        } else {
            if displayedMovieIndex >= (movieList.count - loadMoreTreshold) {
                isLoading = true
                interactor?.searchMovie(
                    query: searchQuery,
                    page: (movieList.count / numberOfMoviesPerPage + 1)
                )
            }
        }
    }

    func searchQueryChanged(query: String) {
        searchQuery = query
        isLoading = true
        guard !query.isEmpty else {
            movieList = []
            self.interactor?.fetchTopMovies(page: 1)
            return
        }
        self.searchTimer?.invalidate()

        searchTimer = Timer.scheduledTimer(
            withTimeInterval: searchDebounceTime,
            repeats: false,
            block: { [weak self] _ in
                DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                    self?.interactor?.searchMovie(query: query, page: 1)
                }
            }
        )
    }

    func movieWasTapped(index: Int) {
        guard movieList.indices.contains(index) else {
            return
        }
        router?.openMovieDetails(movie: movieList[index])
    }
}

extension MovieListPresenter: MovieListInteractorDelegate {
    func addToMovieList(movies: [MovieDTO]) {
        movieList.append(contentsOf: movies.map {
            MovieViewModel(
                movieDTO: $0,
                genres: genres ?? []
            )
        })
        isLoading = false
        view?.updateMovieList()
    }

    func updateSearchResults(movies: [MovieDTO]) {
        isLoading = false
        guard !searchQuery.isEmpty else {
            return
        }
        movieList = movies.map {
            MovieViewModel(
                movieDTO: $0,
                genres: genres ?? []
            )
        }
        DispatchQueue.main.async {
            self.view?.updateMovieList()
        }
    }
}
