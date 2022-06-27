import Foundation
import CoreData
import RxSwift

final class CoreDataManager {
    static let shared = CoreDataManager()
    private let persistentContainer = NSPersistentCloudKitContainer(name: "MovieCoreDataDTO")
    private(set) lazy var context = persistentContainer.viewContext
    
    private init() {
        loadPersistentContainer()
    }
    
    private func loadPersistentContainer() {
        persistentContainer.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func fetch() -> Observable<[Movie]> {
        return Observable.create { [weak self] emitter in
            guard let movies = try? self?.context.fetch(MovieCoreDataDTO.fetchRequest()) else {
                emitter.onError(fatalError())
            }
            
            let bookmarkedMoives = movies.map { $0.toDomain() }
            emitter.onNext(bookmarkedMoives)
            emitter.onCompleted()
            
            return Disposables.create()
        }
    }
    
    func save(_ movie: Movie) {
        let movieObject = MovieCoreDataDTO(context: context)
        movieObject.title = movie.title
        movieObject.link = movie.link
        movieObject.image = movie.image
        movieObject.subtitle = movie.subtitle
        movieObject.pubDate = movie.pubDate
        movieObject.director = movie.director
        movieObject.actor = movie.actor
        movieObject.userRating = movie.userRating
        movieObject.isBookmarked = movie.isBookmarked
        
        saveContextChange()
    }
    
    func delete() {
        
    }
    
    func saveContextChange() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
