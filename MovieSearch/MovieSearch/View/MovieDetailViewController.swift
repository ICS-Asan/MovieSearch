import UIKit
import SnapKit
import WebKit

class MovieDetailViewController: UIViewController {

    private let headerView = UIView()
    private let webView = WKWebView(frame: .zero)
    var movie: Movie?
    
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
