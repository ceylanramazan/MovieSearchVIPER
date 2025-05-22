import Foundation

protocol MovieDetailInteractorProtocol: AnyObject {
    var presenter: MovieDetailPresenterProtocol? { get set }
    func fetchMovieDetail(imdbID: String)
}

class MovieDetailInteractor: MovieDetailInteractorProtocol {
    weak var presenter: MovieDetailPresenterProtocol?
    private let service: BaseServiceProtocol
    
    init(service: BaseServiceProtocol = BaseService()) {
        self.service = service
    }
    
    func fetchMovieDetail(imdbID: String) {
        let params: [String: Any] = ["i": imdbID]
        service.request(endpoint: "", parameters: params) { [weak self] (result: Result<MovieDetail, AppError>) in
            switch result {
            case .success(let detail):
                self?.presenter?.didFetchDetail(detail)
            case .failure(let error):
                self?.presenter?.didFail(error)
            }
        }
    }
} 