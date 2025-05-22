import UIKit

class MovieDetailRouter {
    static func createModule(movie: Movie) -> UIViewController {
        let view = MovieDetailViewController()
        let presenter = MovieDetailPresenter(movie: movie)
        let interactor = MovieDetailInteractor()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
} 