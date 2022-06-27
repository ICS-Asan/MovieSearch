import Foundation

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
}
