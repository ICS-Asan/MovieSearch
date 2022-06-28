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
                print(self?.currentMovie?.title)
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
    
    private func receiveCurrentMovie(_ movie: Movie) {
        currentMovie = movie
    }
}

extension MovieDetailViewModel {
    final class Input {
        let setupViewObserver: Observable<Movie>

        init(
            setupViewObserver: Observable<Movie>
        ) {
            self.setupViewObserver = setupViewObserver
        }
    }

    final class Output { }

}
