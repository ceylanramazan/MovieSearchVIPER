import Foundation

protocol MovieSearchInteractorProtocol: AnyObject {
    var presenter: MovieSearchPresenterProtocol? { get set }
    func searchMovies(query: String)
}

class MovieSearchInteractor: MovieSearchInteractorProtocol {
    weak var presenter: MovieSearchPresenterProtocol?
    private let service: BaseServiceProtocol
    
    init(service: BaseServiceProtocol = BaseService()) {
        self.service = service
    }
    
    func searchMovies(query: String) {
        let params: [String: Any] = ["s": query]
        service.request(endpoint: "", parameters: params) { [weak self] (result: Result<MovieSearchResponse, AppError>) in
            switch result {
            case .success(let response):
                self?.presenter?.moviesFetched(response.search)
            case .failure(let error):
                self?.presenter?.moviesFetchFailed(error)
            }
        }
    }
} 
