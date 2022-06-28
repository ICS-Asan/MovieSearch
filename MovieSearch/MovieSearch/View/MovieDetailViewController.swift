import UIKit
import SnapKit
import WebKit
import RxSwift

class MovieDetailViewController: UIViewController {

    private let headerView = UIView()
    private let webView = WKWebView(frame: .zero)
    private let viewModel = MovieDetailViewModel()
    private let setupViewObserver: PublishSubject<Movie> = .init()
    private let didTabBookmarkButton: PublishSubject<Void> = .init()
    
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
        setupDetailViewLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        webView.stopLoading()
    }
    
    func setupDetailView(with movie: Movie) {
        navigationItem.title = movie.title
        setupHeaderView(with: movie)
        setupWebView(with: movie.link)
        setupViewObserver.onNext(movie)
    }
    
    private func bind() {
        let input = MovieDetailViewModel.Input(
            setupViewObserver: setupViewObserver,
            didTabBookmarkButton: didTabBookmarkButton
        )
        let _ = viewModel.transform(input)
    }

    private func setupDetailViewLayout() {
        view.backgroundColor = .systemBackground
        view.addSubview(headerView)
        view.addSubview(webView)
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(120)
        }
        webView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.leading.trailing.width.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupHeaderView(with movie: Movie) {
        let movieInformationView = MovieInformationView()
        movieInformationView.setupView(with: movie)
        movieInformationView.changeBookmarkState = { self.didTabBookmarkButton.onNext(()) }
        headerView.addSubview(movieInformationView)
        movieInformationView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    private func setupWebView(with url: String) {
        guard let movieUrl = URL(string: url) else { return }
        let request = URLRequest(url: movieUrl)
        webView.allowsBackForwardNavigationGestures = true
        webView.load(request)
    }
}
