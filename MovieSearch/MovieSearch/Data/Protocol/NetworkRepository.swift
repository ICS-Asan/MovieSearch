import Foundation
import RxSwift

protocol NetworkRepository {
    func fetchMovieSearchInformation(with searchWord: String) -> Observable<MovieSearchInformation?>
}
