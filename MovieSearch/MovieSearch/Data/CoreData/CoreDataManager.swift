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
    
    func save() {
        
    }
    
    func delete() {
        
    }
}
