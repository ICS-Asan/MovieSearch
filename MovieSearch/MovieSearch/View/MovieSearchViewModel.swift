import Foundation
import RxSwift

final class MovieSearchViewModel {
    private let movieSearchUseCase = MovieSearchUseCase()
    private(set) var searchResult: [Movie] = []
    
    func fetchSearchResult(with word: String) -> Observable<MovieSearchInformation?> {
        movieSearchUseCase.fetchMovieSearchInformation(with: word)
    }
}
