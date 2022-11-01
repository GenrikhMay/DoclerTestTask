@testable import DoclerTestTask
import XCTest

final class MovieListViewMock: MovieListViewProtocol {
    var updateMovieListWasCalled = false

    var updateMovieListStub: (() -> Void)?
    
    func updateMovieList() {
        updateMovieListWasCalled = true
        updateMovieListStub?()
    }
}
