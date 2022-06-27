import Foundation

enum EndPoint {
    private static let mainPath = "https://openapi.naver.com/v1/search/movie.json"
    
    case movieSearch(word: String, displayCount: Int = 20)

    var url: URL? {
        switch self {
        case .movieSearch(let word, let display):
            var components = URLComponents(string: EndPoint.mainPath)
            let searchWord = URLQueryItem(name: "query", value: "\(word)")
            let display = URLQueryItem(name: "display", value: "\(display)")
            components?.queryItems = [searchWord, display]
            return components?.url
        }
    }
}
