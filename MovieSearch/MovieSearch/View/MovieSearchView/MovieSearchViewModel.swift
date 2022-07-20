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
            .didTabBookmarkButton
            .subscribe(onNext: { [weak self] index in
                self?.toggleBookmarkState(at: index)
            })
            .disposed(by: disposeBag)
        input.viewWillDisappearObservable
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.resetBookmarkState()
            })
            .disposed(by: disposeBag)

        let searchMovieItems = input.searchMovieObservable
            .withUnretained(self)
            .flatMap { (owner, title) in
                owner.movieSearchUseCase.fetchMovieSearchInformation(with: title)
            }
            .map { result -> [Movie] in
                self.storeSearchResult(with: result)
                self.applyBookmarkState()
                return self.searchResults
            }
        
        let reloadMovieItems = input.viewWillAppearObservable
            .skip(1)
            .withUnretained(self)
            .flatMap { (owner, title) in
                owner.movieSearchUseCase.fetchBookmarkedMovie()
            }
            .map { result -> [Movie] in
                self.storeBookmarkedMovie(movies: result)
                self.applyBookmarkState()
                return self.searchResults
            }
        
    
        return Output(searchMovieItemsObservable: searchMovieItems, reloadMovieItemsObservable: reloadMovieItems)
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
    
    func resetBookmarkState() {
        if searchResults.isEmpty == true { return }
        for index in 0..<searchResults.count {
            searchResults[index].isBookmarked = false
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
        let searchMovieObservable: Observable<String>
        let didTabBookmarkButton: Observable<Int>
        let viewWillAppearObservable: Observable<Void>
        let viewWillDisappearObservable: Observable<Void>
        
        init(
            searchMovieObservable: Observable<String>,
            didTabBookmarkButton: Observable<Int>,
            viewWillAppearObservable: Observable<Void>,
            viewWillDisappearObservable: Observable<Void>
        ) {
            self.searchMovieObservable = searchMovieObservable
            self.didTabBookmarkButton = didTabBookmarkButton
            self.viewWillAppearObservable = viewWillAppearObservable
            self.viewWillDisappearObservable = viewWillDisappearObservable
        }
    }
    
    final class Output {
        let movieItemsObservable: Observable<[Movie]>
        let reloadMovieItemsObservable: Observable<[Movie]>
        
        init(
            searchMovieItemsObservable: Observable<[Movie]>,
             reloadMovieItemsObservable: Observable<[Movie]>
        ) {
            self.movieItemsObservable = searchMovieItemsObservable
            self.reloadMovieItemsObservable = reloadMovieItemsObservable
        }
    }
}
