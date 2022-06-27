import Foundation
import RxSwift

final class MovieCoreDataRepository: CoreDataRepository {
    func fetch() -> Observable<[Movie]> {
        return .empty()
    }
    
    func save() {
        
    }
    
    func delete() {
        
    }
}
