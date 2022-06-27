import Foundation

struct MovieDTO: Codable {
    let title: String
    let link: String
    let image: String
    let subtitle: String
    let pubDate: String
    let director: String
    let actor: String
    let userRating: String
    
    func toDomain() -> Movie {
        return Movie(
            title: title,
            link: link,
            image: image,
            subtitle: subtitle,
            pubDate: pubDate,
            director: director,
            actor: actor,
            userRating: userRating)
    }
}
