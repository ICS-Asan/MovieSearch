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
        input
            .didTabBookmarkButton
            .subscribe(onNext: { [weak self] index in
                self?.toggleBookmarkState(at: index)
            })
            .disposed(by: disposeBag)
        
        let bookmarkedMovies = input.viewWillAppearObservable
            .withUnretained(self)
            .flatMap { (owner, _) in
                owner.fetchBookmarkedMovie()
            }
            .map { result -> [Movie] in
                self.storeBookmarkedMovie(movies: result)
                return self.bookmarkedMovie
            }
        
        return Output(loadBookmarkedMovies: bookmarkedMovies)
    }
    
    func fetchBookmarkedMovie() -> Observable<[Movie]> {
        return bookmarkListUseCase.fetchBookmarkedMovie()
    }
    
    private func storeBookmarkedMovie(movies: [Movie]) {
        bookmarkedMovie = movies
    }
    
    private func toggleBookmarkState(at index: Int) {
        let currentBookmarkState = self.bookmarkedMovie[index].isBookmarked
        if currentBookmarkState == true {
            self.bookmarkedMovie[index].isBookmarked = false
            bookmarkListUseCase.deleteBookmarkedMovie(with: self.bookmarkedMovie[index].title)
        } else {
            self.bookmarkedMovie[index].isBookmarked = true
            bookmarkListUseCase.saveBookmarkedMovie(self.bookmarkedMovie[index])
        }
    }
}

extension BookmarkListViewModel {
    final class Input {
        let viewWillAppearObservable: Observable<Void>
        let loadBookmarkedMovie: Observable<[Movie]>
        let didTabBookmarkButton: Observable<Int>

        init(
            viewWillAppearObservable: Observable<Void>,
            loadBookmarkedMovie: Observable<[Movie]>,
            didTabBookmarkButton: Observable<Int>
        ) {
            self.viewWillAppearObservable = viewWillAppearObservable
            self.loadBookmarkedMovie = loadBookmarkedMovie
            self.didTabBookmarkButton = didTabBookmarkButton
        }
    }

    final class Output {
        let loadBookmarkedMovies: Observable<[Movie]>
        
        init(loadBookmarkedMovies: Observable<[Movie]>) {
            self.loadBookmarkedMovies = loadBookmarkedMovies
        }
    }

}
