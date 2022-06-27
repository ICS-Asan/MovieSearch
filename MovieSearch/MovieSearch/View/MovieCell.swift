import UIKit

final class MovieCell: UICollectionViewCell {
    let containerView = MovieInformationView()
    var changeFavoriteState: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func setupCell(with movie: Movie) {
        containerView.setupView(with: movie)
    }
    
    private func commonInit() {
        setupContainerViewLayout()
    }
    
    private func setupContainerViewLayout() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.width.height.equalToSuperview()
        }
    }
}
