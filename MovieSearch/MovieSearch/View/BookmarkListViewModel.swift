import Foundation
import RxSwift

final class BookmarkListViewModel {
    private let bookmarkListUseCase = BookmarkListUseCase()
    private let disposeBag: DisposeBag = .init()
    private(set) var bookmarkedMovie: [Movie] = []
    
    func transform(_ input: Input) -> Output {
        input
            .loadBookmarkedMovie
            .subscribe(onNext: { [weak self] data in
                self?.storeBookmarkedMovie(movies: data)
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
    
    func fetchBookmarkedMovie() -> Observable<[Movie]> {
        return bookmarkListUseCase.fetchBookmarkedMovie()
    }
    
    private func storeBookmarkedMovie(movies: [Movie]) {
        bookmarkedMovie = movies
    }
}

extension BookmarkListViewModel {
    final class Input {
        let loadBookmarkedMovie: Observable<[Movie]>

        init(
            loadBookmarkedMovie: Observable<[Movie]>
        ) {
            self.loadBookmarkedMovie = loadBookmarkedMovie
        }
    }

    final class Output { }

}
