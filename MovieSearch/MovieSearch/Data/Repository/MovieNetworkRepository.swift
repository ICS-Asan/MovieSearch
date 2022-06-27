import Foundation
import RxSwift

final class MovieNetworkRepository: NetworkRepository {
    func fetchMovieSearchInformation(with searchWord: String) -> Observable<MovieSearchInformation?> {
        let movieSearchInformation = HTTPNetworkManager.shared.fetch(with: EndPoint.movieSearch(word: searchWord).url)
            .map { data -> MovieSearchInformation? in
                let decodedData = JSONParser.decodeData(of: data, type: MovieSearhInformationDTO.self)
                
                return decodedData?.toDomain()
            }
        
        return movieSearchInformation
        
    }
}
