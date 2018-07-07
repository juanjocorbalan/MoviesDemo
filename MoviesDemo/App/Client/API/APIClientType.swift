import Foundation
import RxSwift

protocol APIClientType {
	
	associatedtype T

	func getItem(forResource resource: ResourceType) -> Observable<T>
	func getItems(forResource resource: ResourceType) -> Observable<[T]>
	func postItem(forResource resource: ResourceType) -> Observable<T>
	func updateItem(forResource resource: ResourceType) -> Observable<T>
	func deleteItem(forResource resource: ResourceType) -> Observable<T>
}

enum APIError: Error {
	
	case error(String)
	case serialization
	case unauthorized
	case serverError
	case timeout
}
