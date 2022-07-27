import Foundation
import RxSwift

final class HTTPNetworkManager {
    static let shared = HTTPNetworkManager()
    let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    private func createURLRequest(with endPoint: URL?) -> URLRequest? {
        guard let endPoint = endPoint else {
            return nil
        }
        
        var urlRequest = URLRequest(url: endPoint, method: .get)
        urlRequest.setValue(
            ClientInformation.Search.ID.value,
            forHTTPHeaderField: ClientInformation.Search.ID.key
        )
        urlRequest.addValue(
            ClientInformation.Search.Secret.value,
            forHTTPHeaderField: ClientInformation.Search.Secret.key
        )
        
        return urlRequest
    }
    
    func fetch(with endPoint: URL?) -> Observable<Data> {
        guard let urlRequest = createURLRequest(with: endPoint) else {
            return .error(HTTPNetworkError.invalidEndPoint)
        }

        return Observable.create() { [weak self] emitter in
            let task = self?.urlSession.dataTask(with: urlRequest) { (data, response , error) in
                guard error == nil else {
                    emitter.onError(HTTPNetworkError.invalidRequest)
                    return
                }

                if let data = data {
                    emitter.onNext(data)
                }
                emitter.onCompleted()
            }
            task?.resume()

            return Disposables.create() {
                task?.cancel()
            }
        }
    }
}
