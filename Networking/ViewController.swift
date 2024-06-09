// ViewController.swift
import UIKit
import Combine
import NetworkSDK

class ViewController: UIViewController {
    private var collectionView: UICollectionView!
    private let viewModel = MoviesViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    var moviesList: String

    init(moviesList: String) {
        self.moviesList = moviesList
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        if moviesList == "Popular" {
            navigationItem.title = moviesList
            viewModel.getPopularMovies()
        } else {
            navigationItem.title = "Now Playing"
            viewModel.getLatestMovies()
        }
        bindViewModel()

    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 50)
        let itemWidth = (view.frame.width - 30) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
        collectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderView.reuseIdentifier)
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.$movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        
        let movie = viewModel.movies[indexPath.row]
        cell.configure(with: movie)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeaderView.reuseIdentifier, for: indexPath) as! CollectionHeaderView
                headerView.titleLabel.text = moviesList == "Latest" ? "Now Playing" : "Popular" // Set the title text here
                return headerView
            }
            return UICollectionReusableView()
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.movies[indexPath.row]
        let detailVC = MovieDetailViewController(movie: movie)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: 50) // Adjust the height as needed
        }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let threshold: CGFloat = 50
        if offset > threshold {
            navigationItem.title = moviesList == "Latest" ? "Now Playing" : "Popular"
            UIView.animate(withDuration: 0.3) {
                self.navigationController?.navigationBar.alpha = 1
            }
        } else {
            navigationItem.title = ""
            UIView.animate(withDuration: 0.3) {
                self.navigationController?.navigationBar.alpha = 0
            }
        }
    }
}
