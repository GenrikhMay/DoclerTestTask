import Foundation

protocol MovieDetailsPresenterProtocol: AnyObject, UIVIewControllerLifeCycleSupportabble {
    var movie: MovieViewModel { get }
}

final class MovieDetailsPresenter: MovieDetailsPresenterProtocol {
    weak var view: MovieDetailsViewProtocol?
    var interactor: MovieDetailsInteractorProtocol?
    var router: MovieDetailsRouterProtocol?

    private(set) var movie: MovieViewModel

    init(movie: MovieViewModel) {
        self.movie = movie
    }

    func viewDidLoad() {
        interactor?.getCreditsInfo(movieId: movie.id) { [weak self] cast in
            let castString = cast.map { $0.name }.joined(separator: ", ")
            self?.view?.updateCastInfo(cast: castString)
        }
    }
}
