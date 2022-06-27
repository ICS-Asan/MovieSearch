//
//  MovieCoreDataDTO+CoreDataProperties.swift
//  MovieSearch
//
//  Created by Seul Mac on 2022/06/28.
//
//

import Foundation
import CoreData


extension MovieCoreDataDTO {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieCoreDataDTO> {
        return NSFetchRequest<MovieCoreDataDTO>(entityName: "MovieCoreDataDTO")
    }

    @NSManaged public var title: String?
    @NSManaged public var link: String?
    @NSManaged public var image: String?
    @NSManaged public var subtitle: String?
    @NSManaged public var pubDate: String?
    @NSManaged public var director: String?
    @NSManaged public var actor: String?
    @NSManaged public var userRating: String?
    @NSManaged public var isBookmarked: Bool
}

extension MovieCoreDataDTO : Identifiable {

}

extension MovieCoreDataDTO {
    func toDomain() -> Movie {
        return Movie(
            title: title ?? "",
            link: link ?? "",
            image: image ?? "",
            subtitle: subtitle ?? "",
            pubDate: pubDate ?? "",
            director: director ?? "",
            actor: actor ?? "",
            userRating: userRating ?? "",
            isBookmarked: isBookmarked)
    }
}
