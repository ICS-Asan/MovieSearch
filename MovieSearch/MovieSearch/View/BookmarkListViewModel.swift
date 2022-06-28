import Foundation
import RxSwift

final class BookmarkListViewModel {
    private let bookmarkListUseCase = BookmarkListUseCase()
    private var bookmarkedMovie: [Movie] = []
    
    func fetchBookmarkedMovie() -> Observable<[Movie]> {
        return bookmarkListUseCase.fetchBookmarkedMovie()
    }
    
    private func storeBookmarkedMovie(movies: [Movie]) {
        bookmarkedMovie = movies
    }
}
