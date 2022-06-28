import Foundation
import RxSwift

final class MovieSearchViewModel {
    private let movieSearchUseCase = MovieSearchUseCase()
    private let disposeBag: DisposeBag = .init()
    private(set) var searchResults: [Movie] = []
    private(set) var totalResultCount: Int = 0
    private var bookmarkedMovie: [Movie] = []
    
    
    func transform(_ input: Input) -> Output {
        input
            .loadBookmarkedMovie
            .subscribe(onNext: { [weak self] data in
                self?.storeBookmarkedMovie(movies: data)
                self?.applyBookmarkState()
            })
            .disposed(by: disposeBag)
        input
            .searchMovieObserver
            .subscribe(onNext: { [weak self] data in
                self?.storeSearchResult(with: data)
                self?.applyBookmarkState()
            })
            .disposed(by: disposeBag)
        input
            .didTabBookmarkButton
            .subscribe(onNext: { [weak self] index in
                self?.toggleBookmarkState(at: index)
            })
            .disposed(by: disposeBag)

        return Output()
    }
    
    func storeBookmarkedMovie(movies: [Movie]) {
        bookmarkedMovie = movies
    }
    
    func fetchBookmarkedMovie() -> Observable<[Movie]> {
        return movieSearchUseCase.fetchBookmarkedMovie()
    }
    
    func storeSearchResult(with movieInformation: MovieSearchInformation?) {
        guard let movieInformation = movieInformation else { return }
        totalResultCount = movieInformation.total
        searchResults = movieInformation.items
    }
    
    func fetchSearchResult(with word: String) -> Observable<MovieSearchInformation?> {
        movieSearchUseCase.fetchMovieSearchInformation(with: word)
    }
    
    private func applyBookmarkState() {
        bookmarkedMovie.forEach { favorite in
            let index = searchResults.firstIndex(where: { $0.title  == favorite.title })
            changeBookmarkState(at: index)
        }
    }
    
    private func changeBookmarkState(at index: Int?) {
        guard let index = index else { return }
        searchResults[index].isBookmarked = true
    }
    
    private func toggleBookmarkState(at index: Int) {
        let currentBookmarkState = self.searchResults[index].isBookmarked
        if currentBookmarkState == true {
            self.searchResults[index].isBookmarked = false
            movieSearchUseCase.deleteBookmarkedMovie(with: self.searchResults[index].title)
        } else {
            self.searchResults[index].isBookmarked = true
            movieSearchUseCase.saveBookmarkedMovie(self.searchResults[index])
        }
    }
}

extension MovieSearchViewModel {
    final class Input {
        let loadBookmarkedMovie: Observable<[Movie]>
        let searchMovieObserver: Observable<MovieSearchInformation?>
        let didTabBookmarkButton: Observable<Int>

        init(
            loadBookmarkedMovie: Observable<[Movie]>,
            searchMovieObserver: Observable<MovieSearchInformation?>,
            didTabBookmarkButton: Observable<Int>
        ) {
            self.loadBookmarkedMovie = loadBookmarkedMovie
            self.searchMovieObserver = searchMovieObserver
            self.didTabBookmarkButton = didTabBookmarkButton
        }
    }

    final class Output { }

}
