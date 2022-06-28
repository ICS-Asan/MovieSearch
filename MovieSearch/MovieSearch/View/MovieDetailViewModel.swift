import Foundation
import RxSwift

final class MovieDetailViewModel {
    private let movieDetailUseCase = MovieDetailUseCase()
    private let disposeBag: DisposeBag = .init()
    private(set) var movie: Movie?
    
}
