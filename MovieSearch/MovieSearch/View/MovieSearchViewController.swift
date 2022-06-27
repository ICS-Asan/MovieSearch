import UIKit

class MovieSearchViewController: UIViewController {
    let viewTitleLable: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2).bold
        label.text =  "네이버 영화 검색"
        
        return label
    }()
    
    let bookmarkButton: UIButton = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: viewTitleLable)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: bookmarkButton)
    }
    
}
