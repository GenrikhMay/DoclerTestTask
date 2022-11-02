import Foundation
import UIKit

protocol MovieListInteractorDelegate: AnyObject {
    /// Add movies to movie list
    /// - Parameter movies: movies to add
    func addToMovieList(movies: [MovieDTO])

    /// Update search results
    /// - Parameter movies: search result array
    func updateSearchResults(movies: [MovieDTO])
}

protocol MovieListPresenterProtocol: AnyObject,
                                     UISearchBarSupportabble,
                                     UITableViewSupportabble,
                                     UIVIewControllerLifeCycleSupportabble {
    var movieList: [MovieViewModel] { get }
}

final class MovieListPresenter: MovieListPresenterProtocol {
    var interactor: MovieListInteractorProtocol?
    var router: MovieListRouterProtocol?
    weak var view: MovieListViewProtocol?

    private(set) var movieList: [MovieViewModel] = []
    private let loadMoreTreshold: Int = 5
    private let numberOfMoviesPerPage: Int = 20
    private let maxMovies: Int = 100
    private var genres: [GenreViewModel]?
    private var searchTimer: Timer?
    private let searchDebounceTime: Double = 0.5
    private var isLoading: Bool = false
    private var searchQuery: String = ""

    func viewDidLoad() {
        interactor?.setupConfig { [weak self] in
            self?.interactor?.fetchGenres { [weak self] genres in
                self?.genres = genres.map { GenreViewModel(id: $0.id, name: $0.name) }
                self?.interactor?.fetchTopMovies(page: 1)
            }
        }
        isLoading = true
    }

    func willDisplayCell(at index: Int) {
        guard !isLoading else { return }
        if searchQuery.isEmpty {
            guard movieList.count < maxMovies else { return }
            if index >= (movieList.count - loadMoreTreshold) {
                isLoading = true
                interactor?.fetchTopMovies(page: (movieList.count / numberOfMoviesPerPage + 1))
            }
        } else {
            if index >= (movieList.count - loadMoreTreshold) {
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

    func tableViewCellWasTapped(at index: Int) {
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
