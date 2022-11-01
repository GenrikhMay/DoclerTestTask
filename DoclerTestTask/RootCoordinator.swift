import Foundation
import UIKit

struct AppStartingCoordinator {
    let builder: MovieListModuleBuilderProtocol

    init(builder: MovieListModuleBuilderProtocol = MovieListModuleBuilder()) {
        self.builder = builder
    }

    func start(navigationController: UINavigationController) {
        let movieListVC = builder.build(using: navigationController)
        navigationController.pushViewController(movieListVC, animated: true)
    }
}
