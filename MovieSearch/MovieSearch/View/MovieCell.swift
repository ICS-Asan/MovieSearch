import UIKit

final class MovieCell: UICollectionViewCell {
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        
        return label
    }()

    private let directorLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    private let actorLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    private let userRatingLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    private let textInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 5
        
        return stackView
    }()
    
    private let bookmarkButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        button.tintColor = .secondarySystemBackground
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
