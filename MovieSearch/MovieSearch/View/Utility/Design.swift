import UIKit

enum Design {
    enum Text {
        static let movieSearchViewTitle = "네이버 영화 검색"
        static let moveBookmarkListButtonTitle = "즐겨찾기"
        static let bookmarkListViewTitle = "즐겨찾기 목록"
        static let directorTitle = "감독: "
        static let actorTitle = "출연: "
        static let userRatingTitle = "평점: "
        static let defaultPosterURL = "https://i.imgur.com/lQ3niDp.png"
    }
    
    enum Font {
        static let movieSearchViewTitle = UIFont.preferredFont(forTextStyle: .title2).bold
        static let movieInformationTitle = UIFont.preferredFont(forTextStyle: .body).bold
        static let movieInformation = UIFont.preferredFont(forTextStyle: .callout)
    }
    
    enum Color {
        static let defaultBackground = UIColor.systemBackground
        static let border = UIColor.secondarySystemBackground.cgColor
        static let bookmarkedButton = UIColor.systemYellow
        static let normalButton = UIColor.systemGray5
    }
    
    enum Image {
        static let bookmarkButton = UIImage(systemName: "star.fill")
    }
    
    enum Size {
        static let itemWidth = NSCollectionLayoutDimension.fractionalWidth(1.0)
        static let itemHeight = NSCollectionLayoutDimension.estimated(120)
    }
}
