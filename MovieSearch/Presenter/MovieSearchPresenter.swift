import Foundation

protocol MovieSearchPresenterProtocol: AnyObject {
    var view: MovieSearchViewProtocol? { get set }
    var interactor: MovieSearchInteractorProtocol? { get set }
    var router: MovieSearchRouterProtocol? { get set }
    
    func searchMovies(query: String)
    func moviesFetched(_ movies: [Movie])
    func moviesFetchFailed(_ error: Error)
    func didSelectMovie(_ movie: Movie)
}

class MovieSearchPresenter: MovieSearchPresenterProtocol {
    weak var view: MovieSearchViewProtocol?
    var interactor: MovieSearchInteractorProtocol?
    var router: MovieSearchRouterProtocol?
    
    func searchMovies(query: String) {
        interactor?.searchMovies(query: query)
    }
    
    func moviesFetched(_ movies: [Movie]) {
        view?.updateMovies(movies)
    }
    
    func moviesFetchFailed(_ error: Error) {
        view?.showError(error)
    }
    
    func didSelectMovie(_ movie: Movie) {
        router?.navigateToDetail(from: view, movie: movie)
    }
} 