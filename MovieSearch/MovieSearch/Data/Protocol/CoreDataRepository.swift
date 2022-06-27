import Foundation
import RxSwift

protocol CoreDataRepository {
    func fetch() -> Observable<[Movie]>
    func save()
    func delete()
}
