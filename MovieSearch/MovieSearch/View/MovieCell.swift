import UIKit
import SnapKit
import SDWebImage

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
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupPosterImageViewLayout()
        setupTextInformationStackView()
        setupBookmarkButtonLayout()
    }
    
    private func setupPosterImageViewLayout() {
        contentView.addSubview(posterImageView)
        posterImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(5)
            make.height.equalTo(100)
            make.width.equalTo(posterImageView.snp.height).multipliedBy(0.7)
        }
    }
    
    private func setupTextInformationStackViewLayout() {
        setupTextInformationStackView()
        contentView.addSubview(textInformationStackView)
        textInformationStackView.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.trailing).inset(-10)
            make.top.bottom.equalTo(posterImageView)
            make.trailing.equalToSuperview()
        }
    }
    
    private func setupTextInformationStackView() {
        textInformationStackView.addArrangedSubview(titleLabel)
        textInformationStackView.addArrangedSubview(directorLabel)
        textInformationStackView.addArrangedSubview(actorLabel)
        textInformationStackView.addArrangedSubview(userRatingLabel)
    }
    
    private func setupBookmarkButtonLayout() {
        contentView.addSubview(bookmarkButton)
        bookmarkButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(5)
        }
    }
}
