import UIKit

class MovieTabBarController: UITabBarController {
    let searchNavigationController = UINavigationController(rootViewController: MovieSearchViewController())
    let bookmarkNavigationController = UINavigationController(rootViewController: BookmarkListViewController())
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
