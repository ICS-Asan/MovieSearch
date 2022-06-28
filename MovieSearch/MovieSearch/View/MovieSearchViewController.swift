import UIKit
import RxSwift

class MovieSearchViewController: UIViewController {
    private enum Section {
        case list
    }
    
    private let viewTitleLable: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2).bold
        label.text =  "네이버 영화 검색"
        
        return label
    }()
    
    private let bookmarkButton: UIButton = {
        let button = UIButton()
        button.setTitle("즐겨찾기", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .callout)
        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        button.tintColor = .systemYellow
        button.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        button.layer.borderWidth = 1
        
        return button
    }()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.setSearchFieldBackgroundImage(UIImage(), for: .normal)
        searchController.searchBar.barTintColor = .systemBackground
        searchController.searchBar.searchTextField.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        searchController.searchBar.searchTextField.layer.borderWidth = 1
        
        return searchController
    }()
    
    private var movieCollectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Movie>?
    private let viewModel = MovieSearchViewModel()
    private let viewWillAppearObserver: PublishSubject<[Movie]> = .init()
    private let searchMovieObserver: PublishSubject<MovieSearchInformation?> = .init()
    private let didTabBookmarkButton: PublishSubject<Int> = .init()
    private let disposeBag: DisposeBag = .init()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupHomeCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchBookmarkedMovie()
        populate(movie: viewModel.searchResults)
    }
    
    private func bind() {
        let input = MovieSearchViewModel.Input(
            viewWillAppearObserver: viewWillAppearObserver,
            searchMovieObserver: searchMovieObserver,
            didTabBookmarkButton: didTabBookmarkButton
        )
        let _ = viewModel.transform(input)
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: viewTitleLable)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: bookmarkButton)
        bookmarkButton.addTarget(self, action: #selector(presentBookmarkListView), for: .touchDown)
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    private func fetchBookmarkedMovie() {
        viewModel.fetchBookmarkedMovie()
            .subscribe(onNext: { [weak self] data in
                self?.viewWillAppearObserver.onNext(data)
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func presentBookmarkListView() {
        let destination = UINavigationController(rootViewController: BookmarkListViewController())
        destination.view.backgroundColor = .systemBackground
        destination.modalPresentationStyle = .fullScreen
        present(destination, animated: true)
    }
}

extension MovieSearchViewController {
    private func setupHomeCollectionView() {
        movieCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        registerCollectionViewCell()
        setupCollectionViewDataSource()
        setupCollectionViewConstraints()
        movieCollectionView.delegate = self
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            return self.creatListSectionLayout()
        }
        return layout
    }

    private func creatListSectionLayout() -> NSCollectionLayoutSection {
        let itemsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(120))
        let item = NSCollectionLayoutItem(layoutSize: itemsize)
        let groupSize = NSCollectionLayoutSize(widthDimension: itemsize.widthDimension,
                                               heightDimension: itemsize.heightDimension)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func registerCollectionViewCell() {
        movieCollectionView.register(MovieCell.self)
    }
    
    private func setupCollectionViewDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Movie>(collectionView: movieCollectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(MovieCell.self, for: indexPath) else {
                return UICollectionViewCell()
            }
            cell.containerView.changeBookmarkState = {
                self.didTabBookmarkButton.onNext(indexPath.row)
            }
            cell.setupCell(with: item)
            return cell
        }
        movieCollectionView.dataSource = dataSource
    }
    
    private func setupCollectionViewConstraints() {
        view.addSubview(movieCollectionView)
        movieCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func populate(movie: [Movie]?) {
        guard let movie = movie else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapshot.appendSections([.list])
        snapshot.appendItems(movie, toSection: .list)
        dataSource?.apply(snapshot)
    }
}

extension MovieSearchViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let searchWord = searchBar.searchTextField.text,
              searchWord.isEmpty == false else { return }
        viewModel.fetchSearchResult(with: searchWord)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                self?.searchMovieObserver.onNext(result)
                self?.populate(movie: self?.viewModel.searchResults)
            })
            .disposed(by: disposeBag)
        fetchBookmarkedMovie()
    }
}

extension MovieSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.searchResults[indexPath.row]
        let destination = MovieDetailViewController()
        navigationController?.pushViewController(destination, animated: true)
        destination.setupDetailView(with: movie)
        
    }
}
