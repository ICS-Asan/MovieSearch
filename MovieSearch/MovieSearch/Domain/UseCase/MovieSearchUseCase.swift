import Foundation
import RxSwift

final class MovieSearchUseCase {
    let movieNetworkRepository: NetworkRepository
    
    init(movieNetworkRepository: NetworkRepository = MovieNetworkRepository()) {
        self.movieNetworkRepository = movieNetworkRepository
    }
    
    func fetchMovieSearchInformation(with searchWord: String) -> Observable<MovieSearchInformation?> {
        return movieNetworkRepository.fetchMovieSearchInformation(with: searchWord)
    }
}
