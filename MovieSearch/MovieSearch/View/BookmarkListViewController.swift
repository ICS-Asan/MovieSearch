import UIKit

class BookmarkListViewController: UIViewController {
    private enum Section {
        case list
    }
    
    private var bookmarkCollectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Movie>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupBookmarkCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissView))
        navigationItem.title = "즐겨찾기 목록"
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
