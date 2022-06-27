import Foundation

struct MovieSearhInformationDTO: Codable {
    let lastBuildDate: String
    let total: Int
    let start: Int
    let display: Int
    let items: [MovieDTO]
    
    func toDomain() -> MovieSearhInformation {
        let movies = items.map { $0.toDomain() }
        return MovieSearhInformation(
            lastBuildDate: lastBuildDate,
            total: total,
            start: start,
            display: display,
            items: movies
            )
    }
}
