import Foundation
import RxSwift

final class MovieDetailViewModel {
    private let movieDetailUseCase = MovieDetailUseCase()
    private let disposeBag: DisposeBag = .init()
    private(set) var currentMovie: Movie?
    
    func transform(_ input: Input) -> Output {
        input
            .setupViewObserver
            .subscribe(onNext: { [weak self] movie in
                self?.receiveCurrentMovie(movie)
            })
            .disposed(by: disposeBag)
        input
            .didTabBookmarkButton
            .subscribe(onNext: { [weak self] in
                self?.toggleBookmarkState()
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
    
    private func receiveCurrentMovie(_ movie: Movie) {
        currentMovie = movie
    }
    
    private func toggleBookmarkState() {
        guard let currentMovie = currentMovie else { return }
        let currentBookmarkState = currentMovie.isBookmarked
        if currentBookmarkState == true {
            movieDetailUseCase.deleteBookmarkedMovie(with: currentMovie.title)
        } else {
            var movie = currentMovie
            movie.isBookmarked = true
            movieDetailUseCase.saveBookmarkedMovie(movie)
        }
    }
}

extension MovieDetailViewModel {
    final class Input {
        let setupViewObserver: Observable<Movie>
        let didTabBookmarkButton: Observable<Void>
        init(
            setupViewObserver: Observable<Movie>,
            didTabBookmarkButton: Observable<Void>
        ) {
            self.setupViewObserver = setupViewObserver
            self.didTabBookmarkButton = didTabBookmarkButton
        }
    }

    final class Output { }

}
