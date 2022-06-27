import Foundation
import RxSwift

final class HTTPNetworkManager {
    static let shared = HTTPNetworkManager()
    let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func createURLRequest(with endPoint: URL?) -> URLRequest? {
        guard let endPoint = endPoint else {
            return nil
        }
        var urlRequest = URLRequest(url: endPoint, method: .get)
        urlRequest.setValue(
            ClientInformation.ID.key,
            forHTTPHeaderField: ClientInformation.ID.value
        )
        urlRequest.addValue(
            ClientInformation.Secret.key,
            forHTTPHeaderField: ClientInformation.Secret.value
        )
        
        return urlRequest
    }
    
    func fetch(with endPoint: URL?) -> Observable<Data> {
        guard let endPoint = endPoint else {
            return .error(fatalError())
        }

        return Observable.create() { [weak self] emitter in
            let urlRequest = URLRequest(url: endPoint, method: .get)
            let task = self?.urlSession.dataTask(with: urlRequest) { (data, response , error) in
                guard error == nil else {
                    emitter.onError(fatalError())
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
