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
            .didTabBookmarkButton
            .subscribe(onNext: { [weak self] index in
                self?.toggleBookmarkState(at: index)
            })
            .disposed(by: disposeBag)

        let movieItem = input.searchMovieObserver
            .withUnretained(self)
            .flatMap { (owner, title) in
                owner.movieSearchUseCase.fetchMovieSearchInformation(with: title)
            }
            .map { result -> [Movie] in
                self.storeSearchResult(with: result)
                self.applyBookmarkState()
                return self.searchResults
            }
        
    
        return Output(movieItemsObservable: movieItem)
    }
    
    func fetchBookmarkedMovie() -> Observable<[Movie]> {
        return movieSearchUseCase.fetchBookmarkedMovie()
    }

    func fetchSearchResult(with word: String) -> Observable<MovieSearchInformation?> {
        if word.isEmpty == true {
            return .empty()
        }
        return movieSearchUseCase.fetchMovieSearchInformation(with: word)
    }
    
    func resetBookmarkState() -> Observable<[Movie]?> {
        return Observable.create { [weak self] emitter in
            self?.bookmarkedMovie.forEach { favorite in
                let index = self?.searchResults.firstIndex(where: { $0.title  == favorite.title })
                self?.changeBookmarkState(at: index, to: false)
            }
            emitter.onNext(self?.searchResults)
            emitter.onCompleted()
            
            return Disposables.create()
        }
    }
    
    private func storeBookmarkedMovie(movies: [Movie]) {
        bookmarkedMovie = movies
    }
    
    private func storeSearchResult(with movieInformation: MovieSearchInformation?) {
        guard let movieInformation = movieInformation else { return }
        totalResultCount = movieInformation.total
        searchResults = movieInformation.items
    }
    
    private func applyBookmarkState() {
        bookmarkedMovie.forEach { favorite in
            let index = searchResults.firstIndex(where: { $0.title  == favorite.title })
            changeBookmarkState(at: index, to: true)
        }
    }
    
    private func toggleBookmarkState(at index: Int) {
        let currentBookmarkState = self.searchResults[index].isBookmarked
        if currentBookmarkState == true {
            changeBookmarkState(at: index, to: false)
            movieSearchUseCase.deleteBookmarkedMovie(with: self.searchResults[index].title)
        } else {
            changeBookmarkState(at: index, to: true)
            movieSearchUseCase.saveBookmarkedMovie(self.searchResults[index])
        }
    }
    
    private func changeBookmarkState(at index: Int?, to state: Bool) {
        guard let index = index else { return }
        searchResults[index].isBookmarked = state
    }
}

extension MovieSearchViewModel {
    final class Input {
        let loadBookmarkedMovie: Observable<[Movie]>
        let searchMovieObserver: Observable<String>
        let didTabBookmarkButton: Observable<Int>
        
        init(
            loadBookmarkedMovie: Observable<[Movie]>,
            searchMovieObserver: Observable<String>,
            didTabBookmarkButton: Observable<Int>
        ) {
            self.loadBookmarkedMovie = loadBookmarkedMovie
            self.searchMovieObserver = searchMovieObserver
            self.didTabBookmarkButton = didTabBookmarkButton
        }
    }
    
    final class Output {
        let movieItemsObservable: Observable<[Movie]>
        
        init(movieItemsObservable: Observable<[Movie]>) {
            self.movieItemsObservable = movieItemsObservable
        }
    }
}
