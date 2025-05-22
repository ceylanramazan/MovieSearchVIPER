import Foundation

protocol MovieDetailPresenterProtocol: AnyObject {
    var view: MovieDetailViewProtocol? { get set }
    var interactor: MovieDetailInteractorProtocol? { get set }
    func viewDidLoad()
    func didFetchDetail(_ detail: MovieDetail)
    func didFail(_ error: Error)
}

class MovieDetailPresenter: MovieDetailPresenterProtocol {
    weak var view: MovieDetailViewProtocol?
    var interactor: MovieDetailInteractorProtocol?
    private let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    func viewDidLoad() {
        interactor?.fetchMovieDetail(imdbID: movie.imdbID)
    }
    
    func didFetchDetail(_ detail: MovieDetail) {
        view?.showDetail(detail)
    }
    
    func didFail(_ error: Error) {
        view?.showError(error)
    }
} 