import Foundation
import RxSwift

final class MovieSearchViewModel {
    private let movieSearchUseCase = MovieSearchUseCase()
    private let disposeBag: DisposeBag = .init()
    private(set) var searchResults: [Movie] = []
    private(set) var totalResultCount: Int = 0
    
    
    func transform(_ input: Input) -> Output {
        input
            .searchMovieObserver
            .subscribe(onNext: { [weak self] data in
                self?.storeSearchResult(with: data)
            })
            .disposed(by: disposeBag)

        return Output()
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
        let searchMovieObserver: Observable<MovieSearchInformation?>

        init(
            searchMovieObserver: Observable<MovieSearchInformation?>
        ) {
            self.searchMovieObserver = searchMovieObserver
        }
    }

    final class Output { }

}
