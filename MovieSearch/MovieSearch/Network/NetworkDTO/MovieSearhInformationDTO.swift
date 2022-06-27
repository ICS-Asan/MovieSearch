import Foundation

struct MovieSearhInformationDTO: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [MovieDTO]
}
