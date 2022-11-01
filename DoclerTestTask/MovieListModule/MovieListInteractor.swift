import Foundation

protocol MovieListInteractorProtocol {
    /// Set up config variables
    /// - Parameter completion: callback
    func setupConfig(completion: @escaping() -> Void)

    /// Get top movies
    /// - Parameter page: results page number
    func fetchTopMovies(page: Int)

    /// Get genres list
    /// - Parameter completion: callback
    func fetchGenres(completion: @escaping ([Genre]) -> Void)

    /// Search movie using API
    /// - Parameters:
    ///   - query: search query
    ///   - page: search results page number
    func searchMovie(query: String, page: Int)
}

final class MovieListInteractor: MovieListInteractorProtocol {
    let movieNetworkService: MovieNetworkServiceProtocol
    let configNetworkService: ConfigurationNetworkServiceProtocol

    weak var delegate: MovieListInteractorDelegate?

    init(
        movieNetworkService: MovieNetworkServiceProtocol = MovieNetworkService(),
        configNetworkService: ConfigurationNetworkServiceProtocol = ConfigurationNetworkService()
    ) {
        self.movieNetworkService = movieNetworkService
        self.configNetworkService = configNetworkService
    }

    func setupConfig(completion: @escaping () -> Void) {
        configNetworkService.getConfiguration { [weak self] result in
            switch result {
            case .success(let configResponse):
                self?.setupConfig(configResponse: configResponse)
            case .error(let error):
                print(error)
            }
            completion()
        }
    }

    private func setupConfig(configResponse: ConfigurationNetworkResponse) {
        if let baseUrl = configResponse.images.secureBaseUrl {
            MovieApiConfiguration.shared.addValue(
                key: .imageBaseURL,
                value: baseUrl
            )
        }
        if let previewSize = configResponse.images.posterSizes.first {
            MovieApiConfiguration.shared.addValue(
                key: .previewPosterSize,
                value: previewSize
            )

            let numberOfsizes = configResponse.images.posterSizes.indices.count
            guard numberOfsizes > 1 else {
                MovieApiConfiguration.shared.addValue(
                    key: .fullPosterSize,
                    value: previewSize
                )
                return
            }
            let fullSize = configResponse.images.posterSizes[numberOfsizes / 2]
            // biggest poster is too heavy
            MovieApiConfiguration.shared.addValue(
                key: .fullPosterSize,
                value: fullSize
            )
        }
    }

    func fetchTopMovies(page: Int) {
        movieNetworkService.getPopularMovies(page: page) { [weak self] result in
            switch result {
            case .success(let response):
                self?.delegate?.addToMovieList(movies: response.results)
            case .error(let error):
                print(error)
            }
        }
    }

    func fetchGenres(completion: @escaping ([Genre]) -> Void) {
        movieNetworkService.getGenres { result in
            switch result {
            case .success(let response):
                completion(response.genres)
            case .error:
                completion([])
            }
        }
    }

    func searchMovie(query: String, page: Int) {
        movieNetworkService.searchMovie(query: query, page: page) { [weak self] result in
            switch result {
            case .success(let response):
                if page == 1 {
                    self?.delegate?.updateSearchResults(movies: response.results)
                } else {
                    self?.delegate?.addToMovieList(movies: response.results)
                }
            case .error:
                self?.delegate?.updateSearchResults(movies: [])
            }
        }
    }
}
