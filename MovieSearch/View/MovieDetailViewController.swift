import UIKit

protocol MovieDetailViewProtocol: AnyObject {
    var presenter: MovieDetailPresenterProtocol? { get set }
    func showDetail(_ detail: MovieDetail)
    func showError(_ error: Error)
}

class MovieDetailViewController: UIViewController, MovieDetailViewProtocol {
    var presenter: MovieDetailPresenterProtocol?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let yearLabel = UILabel()
    private let genreLabel = UILabel()
    private let imdbLabel = UILabel()
    private let plotLabel = UILabel()
    private let cardView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 24
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.10
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.layer.shadowRadius = 16
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 18
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.numberOfLines = 2
        
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.font = .systemFont(ofSize: 16, weight: .medium)
        yearLabel.textColor = .secondaryLabel
        
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        genreLabel.font = .systemFont(ofSize: 15, weight: .regular)
        genreLabel.textColor = .systemBlue
        
        imdbLabel.translatesAutoresizingMaskIntoConstraints = false
        imdbLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        imdbLabel.textColor = .systemYellow
        
        plotLabel.translatesAutoresizingMaskIntoConstraints = false
        plotLabel.font = .systemFont(ofSize: 16)
        plotLabel.numberOfLines = 0
        plotLabel.textColor = .label
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(cardView)
        cardView.addSubview(posterImageView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(yearLabel)
        cardView.addSubview(genreLabel)
        cardView.addSubview(imdbLabel)
        cardView.addSubview(plotLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: plotLabel.bottomAnchor, constant: 24),
            
            posterImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24),
            posterImageView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 180),
            posterImageView.heightAnchor.constraint(equalToConstant: 260),
            
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            yearLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            
            genreLabel.centerYAnchor.constraint(equalTo: yearLabel.centerYAnchor),
            genreLabel.leadingAnchor.constraint(equalTo: yearLabel.trailingAnchor, constant: 12),
            
            imdbLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 8),
            imdbLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            
            plotLabel.topAnchor.constraint(equalTo: imdbLabel.bottomAnchor, constant: 16),
            plotLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            plotLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16)
        ])
    }
    
    func showDetail(_ detail: MovieDetail) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.title = detail.title
            self.titleLabel.text = detail.title
            self.yearLabel.text = detail.year
            self.genreLabel.text = detail.genre
            self.imdbLabel.text = "IMDB: \(detail.imdbRating ?? "-")"
            self.plotLabel.text = detail.plot
            self.posterImageView.image = UIImage(systemName: "film")
            if let poster = detail.poster, let url = URL(string: poster), poster != "N/A" {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data {
                        DispatchQueue.main.async {
                            self.posterImageView.image = UIImage(data: data)
                        }
                    }
                }.resume()
            }
        }
    }
    
    func showError(_ error: Error) {
        let alert = UIAlertController(title: "Hata", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
} 