import UIKit

protocol MovieSearchViewProtocol: AnyObject {
    var presenter: MovieSearchPresenterProtocol? { get set }
    func updateMovies(_ movies: [Movie])
    func showError(_ error: Error)
}

class MovieSearchViewController: UIViewController {
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Film ara..."
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 12
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.register(MovieGridCell.self, forCellWithReuseIdentifier: "MovieGridCell")
        return collectionView
    }()
    
    var presenter: MovieSearchPresenterProtocol?
    private var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegates()
        presenter?.searchMovies(query: "Marvel")
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        title = "Film Ara"
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupDelegates() {
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Uyarı", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}

extension MovieSearchViewController: MovieSearchViewProtocol {
    func updateMovies(_ movies: [Movie]) {
        self.movies = movies
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func showError(_ error: Error) {
        DispatchQueue.main.async {
            let message = error.localizedDescription == "Too many results." ? "Daha fazla harf giriniz." : error.localizedDescription
            self.showAlert(message: message)
            self.movies = []
            self.collectionView.reloadData()
        }
    }
}

extension MovieSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {}
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let trimmedText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if trimmedText.count < 3 {
            showAlert(message: "Arama yapmak için en az 3 harf giriniz.")
            movies = []
            collectionView.reloadData()
            return
        }
        presenter?.searchMovies(query: trimmedText)
        searchBar.resignFirstResponder()
    }
}

extension MovieSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as? MovieGridCell else {
            return UICollectionViewCell()
        }
        let movie = movies[indexPath.item]
        cell.configure(with: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 12) / 2
        return CGSize(width: width, height: width * 1.6)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        presenter?.didSelectMovie(movie)
    }
}

class MovieGridCell: UICollectionViewCell {
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 14
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.08
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 6
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(yearLabel)
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.4),
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            yearLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            yearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            yearLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        yearLabel.text = movie.year
        posterImageView.image = UIImage(systemName: "film")
        if let url = URL(string: movie.poster), movie.poster != "N/A" {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self?.posterImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
} 
