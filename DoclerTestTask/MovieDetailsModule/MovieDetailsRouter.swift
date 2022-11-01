import Foundation
import UIKit

protocol MovieDetailsRouterProtocol {}

final class MovieDetailsRouter: MovieDetailsRouterProtocol {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
