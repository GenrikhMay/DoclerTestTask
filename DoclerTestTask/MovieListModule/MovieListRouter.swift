import Foundation
import UIKit

protocol MovieListRouterProtocol {
    /// Show movie details screen
    /// - Parameter movie: movie to show
    func openMovieDetails(movie: MovieViewModel)
}

final class MovieListRouter: MovieListRouterProtocol {
    private let navigationController: UINavigationController
    private let builder: MovieDetailsModuleBuilderProtocol
    weak var view: UIViewController?

    init(
        navigationController: UINavigationController,
        builder: MovieDetailsModuleBuilderProtocol = MovieDetailsModuleBuilder()
    ) {
        self.navigationController = navigationController
        self.builder = builder
    }

    func openMovieDetails(movie: MovieViewModel) {
        let movieDetailVC = builder.build(
            movieInfo: movie,
            using: navigationController
        )
        navigationController.pushViewController(movieDetailVC, animated: true)
    }
}
