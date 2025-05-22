import UIKit

protocol MovieSearchRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func navigateToDetail(from view: MovieSearchViewProtocol?, movie: Movie)
}

class MovieSearchRouter: MovieSearchRouterProtocol {
    static func createModule() -> UIViewController {
        let view = MovieSearchViewController()
        let presenter = MovieSearchPresenter()
        let interactor = MovieSearchInteractor()
        let router = MovieSearchRouter()
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        return view
    }
    
    func navigateToDetail(from view: MovieSearchViewProtocol?, movie: Movie) {
        guard let viewController = view as? UIViewController else { return }
        let detailVC = MovieDetailRouter.createModule(movie: movie)
        viewController.navigationController?.pushViewController(detailVC, animated: true)
    }
} 