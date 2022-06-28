import UIKit
import RxSwift

class BookmarkListViewController: UIViewController {
    private enum Section {
        case list
    }
    
    private var bookmarkCollectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Movie>?
    private let viewModel = BookmarkListViewModel()
    private let loadBookmarkedMovie: PublishSubject<[Movie]> = .init()
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
        setupBookmarkCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchBookmarkedMovie()
        populate(movie: viewModel.bookmarkedMovie)
    }
    
    private func bind() {
        let input = BookmarkListViewModel.Input(
            loadBookmarkedMovie: loadBookmarkedMovie
        )
        let _ = viewModel.transform(input)
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissView))
        navigationItem.title = "즐겨찾기 목록"
    }
    
    private func fetchBookmarkedMovie() {
        viewModel.fetchBookmarkedMovie()
            .subscribe(onNext: { [weak self] data in
                self?.loadBookmarkedMovie.onNext(data)
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func dismissView() {
        dismiss(animated: true)
    }
}

extension BookmarkListViewController {
    private func setupBookmarkCollectionView() {
        bookmarkCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        setupCollectionViewConstraints()
        registerCollectionViewCell()
        setupCollectionViewDataSource()
        bookmarkCollectionView.delegate = self
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
    
    private func setupCollectionViewConstraints() {
        view.addSubview(bookmarkCollectionView)
        bookmarkCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func registerCollectionViewCell() {
        bookmarkCollectionView.register(MovieCell.self)
    }
    
    private func setupCollectionViewDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Movie>(collectionView: bookmarkCollectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(MovieCell.self, for: indexPath) else {
                return UICollectionViewCell()
            }
            cell.setupCell(with: item)
            return cell
        }
        bookmarkCollectionView.dataSource = dataSource
    }
    
    private func populate(movie: [Movie]?) {
        guard let movie = movie else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapshot.appendSections([.list])
        snapshot.appendItems(movie, toSection: .list)
        dataSource?.apply(snapshot)
    }
}

extension BookmarkListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.bookmarkedMovie[indexPath.row]
        let destination = MovieDetailViewController()
        navigationController?.pushViewController(destination, animated: true)
        destination.setupDetailView(with: movie)
        
    }
}
