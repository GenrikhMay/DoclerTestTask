import Foundation
import UIKit

protocol MovieDetailsModuleBuilderProtocol {
    /// Create MovieDetails VIPER module
    /// - Parameter movieInfo: movie info
    /// - Parameter navigationController: navigation controller
    /// - Returns: MovieListViewController with all needed dependencies set
    func build(
        movieInfo: MovieViewModel,
        using navigationController: UINavigationController
    ) -> MovieDetailsViewController
}

struct MovieDetailsModuleBuilder: MovieDetailsModuleBuilderProtocol {

    func build(
        movieInfo: MovieViewModel,
        using navigationController: UINavigationController
    ) -> MovieDetailsViewController {
        let router = MovieDetailsRouter(navigationController: navigationController)
        let presenter = MovieDetailsPresenter(movie: movieInfo)
        let interactor = MovieDetailsInteractor()
        let view = MovieDetailsViewController(
            nibName: String(describing: MovieDetailsViewController.self),
            bundle: nil
        )

        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        view.presenter = presenter

        return view
    }
}
