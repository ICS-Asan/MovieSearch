import Foundation

enum EndPoint {
    private static let mainPath = "    https://openapi.naver.com/v1/search/movie.json"
    
    case movieSearch(word: String)

    var url: URL? {
        switch self {
        case .movieSearch(let word):
            var components = URLComponents(string: EndPoint.mainPath)
            let searchWord = URLQueryItem(name: "query", value: "\(word)")
            components?.queryItems = [searchWord]
            return components?.url
        }
    }
}
