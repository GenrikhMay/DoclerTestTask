import Foundation
import UIKit

struct AppStartingCoordinator {
    let builder: MovieListModuleBuilderProtocol

    init(builder: MovieListModuleBuilderProtocol = MovieListModuleBuilder()) {
        self.builder = builder
    }

    /// Show app's starting VC
    /// - Returns: VC used to start the app
    func start() -> UIViewController {
        let navigationController = UINavigationController()
        let movieListVC = builder.build(using: navigationController)
        navigationController.pushViewController(movieListVC, animated: true)
        return navigationController
    }
}
