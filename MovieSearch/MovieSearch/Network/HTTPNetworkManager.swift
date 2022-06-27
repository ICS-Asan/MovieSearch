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
        urlRequest.setValue("X-Naver-Client-Id", forHTTPHeaderField: "xIDxQUaIwFGS6sVcbAyN")
        urlRequest.addValue("X-Naver-Client-Secret", forHTTPHeaderField: "mJPepkAAi3")
        
        return urlRequest
    }
}
