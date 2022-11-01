import UIKit

protocol MovieListModuleBuilderProtocol {
    /// Build MovieList VIPER module
    /// - Parameter navigationController: navigation controller
    /// - Returns: MovieListViewController with all needed dependencies set
    func build(using navigationController: UINavigationController) -> UIViewController
}

struct MovieListModuleBuilder: MovieListModuleBuilderProtocol {

    func build(using navigationController: UINavigationController) -> UIViewController {
        let router = MovieListRouter(navigationController: navigationController)
        let presenter = MovieListPresenter()
        let interactor = MovieListInteractor()
        let view = MovieListViewController(
            nibName: String(describing: MovieListViewController.self),
            bundle: nil
        )

        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        view.presenter = presenter
        interactor.delegate = presenter

        return view
    }
}
