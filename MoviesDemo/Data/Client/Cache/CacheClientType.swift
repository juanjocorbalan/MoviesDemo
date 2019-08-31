import Foundation
import RxSwift

protocol CacheClientType {
	associatedtype T
	
	func getAll() -> Observable<[T]>
	func get(quantity: Int?, orderedBy key: String?, ascending: Bool?) -> Observable<[T]>
	func get<V>(key: String, value: V) -> Observable<[T]>
	func createOrUpdate(element: T) -> Observable<Void>
	func delete<V>(key: String, value: V) -> Observable<Void>
	func deleteAll() -> Observable<Void>
}

enum CacheError: Error {
	case error
	case notFound
}
