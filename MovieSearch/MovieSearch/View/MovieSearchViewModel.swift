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
            .viewWillAppearObserver
            .subscribe(onNext: { [weak self] data in
                self?.storeBookmarkedMovie(movies: data)
            })
            .disposed(by: disposeBag)
        input
            .searchMovieObserver
            .subscribe(onNext: { [weak self] data in
                self?.storeSearchResult(with: data)
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
}

extension MovieSearchViewModel {
    final class Input {
        let viewWillAppearObserver: Observable<[Movie]>
        let searchMovieObserver: Observable<MovieSearchInformation?>

        init(
            viewWillAppearObserver: Observable<[Movie]>,
            searchMovieObserver: Observable<MovieSearchInformation?>
        ) {
            self.viewWillAppearObserver = viewWillAppearObserver
            self.searchMovieObserver = searchMovieObserver
        }
    }

    final class Output { }

}
