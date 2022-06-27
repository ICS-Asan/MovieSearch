import UIKit
import SnapKit
import SDWebImage

final class MovieInformationView: UIView {
    var changeBookmarkState: (() -> Void)?
    private var isBookmarked: Bool {
        return bookmarkButton.tintColor == .systemYellow
    }

    private let posterImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body).bold
        
        return label
    }()

    private let directorLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        
        return label
    }()
    
    private let actorLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        
        return label
    }()
    
    private let userRatingLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        
        return label
    }()
    
    private let textInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 5
        stackView.distribution = .equalSpacing
        
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
    
    func setupView(with movie: Movie) {
        setupPosterImageView(url: movie.image)
        setupTitleLabel(with: movie.title)
        setupDirectorLabel(with: movie.director)
        setupActorLabel(with: movie.actor)
        setupUserRatingLable(with: movie.userRating)
        setupBookmarkButtonColor(with: movie.isBookmarked)
    }
    
    private func setupPosterImageView(url: String) {
        posterImageView.sd_setImage(with: URL(string: url))
    }
    
    private func setupTitleLabel(with title: String) {
        titleLabel.text = title
    }
    
    private func setupDirectorLabel(with director:String) {
        directorLabel.text = "감독: " + director
    }
    
    private func setupActorLabel(with actor: String) {
        actorLabel.text = "출연: " + actor
    }
    
    private func setupUserRatingLable(with userRating: String) {
        userRatingLabel.text = "평점: " + userRating
    }
    
    private func setupBookmarkButtonColor(with isBookmarked: Bool) {
        if isBookmarked {
            bookmarkButton.tintColor = .systemYellow
        } else {
            bookmarkButton.tintColor = .secondarySystemBackground
        }
    }
    
    
    private func commonInit() {
        setupPosterImageViewLayout()
        setupTextInformationStackViewLayout()
        setupBookmarkButtonLayout()
    }
    
    private func setupBookmarkButtonAction() {
        bookmarkButton.addTarget(self, action: #selector(didTabBookmarkButton), for: .touchDown)
    }
    
    private func setupPosterImageViewLayout() {
        addSubview(posterImageView)
        posterImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(posterImageView.snp.height).multipliedBy(0.7)
        }
    }
    
    private func setupTextInformationStackViewLayout() {
        setupTextInformationStackView()
        addSubview(textInformationStackView)
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
        addSubview(bookmarkButton)
        bookmarkButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
        }
    }
    
    @objc private func didTabBookmarkButton() {
        changeBookmarkState?()
        setupBookmarkButtonColor(with: !isBookmarked)
    }
}
