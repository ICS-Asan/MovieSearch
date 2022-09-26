import UIKit

enum Design {
    enum Text {
        static let boxOfficeViewTabBarTitle = "박스오피스"
        static let searchViewTabBarTitle = "검색"
        static let bookmarkListViewTabBarTitle = "즐겨찾기"
        static let boxOfficeViewTitle = "일간 박스오피스"
        static let movieSearchViewTitle = "영화 검색"
        static let bookmarkListViewTitle = "즐겨찾기 목록"
        static let boxOfficeNewBadgeTitle = "NEW"
        static let directorTitle = "감독: "
        static let actorTitle = "출연: "
        static let userRatingTitle = "평점: "
        static let defaultPosterURL = "https://i.imgur.com/lQ3niDp.png"
    }
    
    enum Font {
        static let rankBadge = UIFont.preferredFont(forTextStyle: .title3).bold
        static let rankChange = UIFont.preferredFont(forTextStyle: .callout)
        static let boxOfficeMovieTtitle = UIFont.preferredFont(forTextStyle: .title3).bold
        static let boxOfficeNexBadgeTitle = UIFont.preferredFont(forTextStyle: .callout).bold
        static let movieSearchViewTitle = UIFont.preferredFont(forTextStyle: .title2).bold
        static let movieInformationTitle = UIFont.preferredFont(forTextStyle: .body).bold
        static let movieInformation = UIFont.preferredFont(forTextStyle: .callout)
    }
    
    enum Color {
        static let main = UIColor(red: 203/255, green: 186/255, blue: 235/255, alpha: 1)
        static let defaultBackground = UIColor.systemBackground
        static let border = UIColor.secondarySystemBackground.cgColor
        static let bookmarkedButton = UIColor.systemYellow
        static let normalButton = UIColor.systemGray5
        static let cellDivider = UIColor.systemGray4.cgColor
    }
    
    enum Image {
        static let normalBoxOffice = UIImage(systemName: "chart.bar")
        static let selectedBoxOffice = UIImage(systemName: "chart.bar.fill")
        static let rankChangeNone = UIImage(systemName: "minus")
        static let rankIncrease = UIImage(systemName: "arrowtriangle.up.fill")
        static let rankDecrease = UIImage(systemName: "arrowtriangle.down.fill")
        static let search = UIImage(systemName: "magnifyingglass")
        static let normalBookmark = UIImage(systemName: "star")
        static let selectedbookmark = UIImage(systemName: "star.fill")
        static let bookmarkButton = UIImage(systemName: "star.fill")
    }
    
    enum Size {
        static let itemWidth = NSCollectionLayoutDimension.fractionalWidth(1.0)
        static let itemHeight = NSCollectionLayoutDimension.estimated(120)
    }
}
