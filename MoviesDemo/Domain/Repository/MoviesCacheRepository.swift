import Foundation
import RxSwift

protocol MoviesCacheRepositoryType {
	func getAll() -> Observable<[Movie]>
	func deleteAll() -> Observable<Void>
	func get(by id: String) -> Observable<Movie>
	func get<V>(where key: String, equals value: V) -> Observable<[Movie]>
	func delete(by id: String) -> Observable<Void>
	func createOrUpdate(movie: Movie) -> Observable<Void>
}

class MoviesCacheRepository<CacheClient>: MoviesCacheRepositoryType where CacheClient: CacheClientType, CacheClient.T == Movie {
	
	private let cacheClient: CacheClient
	
	private let bag = DisposeBag()
	
	init(cacheClient: CacheClient) {
		self.cacheClient = cacheClient
	}
	
	func getAll() -> Observable<[Movie]> {
		return cacheClient.getAll()
	}
	
	func deleteAll() -> Observable<Void> {
		return cacheClient.deleteAll()
	}

	func get(by id: String) -> Observable<Movie> {
		return cacheClient.get(key: MoviesCache.keys.identifier, value: id)
			.flatMap { movies -> Observable<Movie> in
				if movies.isEmpty {
					return Observable.error(CacheError.notFound)
				} else {
					return Observable.just(movies.first!)
				}
			}
	}
	
	func delete(by id: String) -> Observable<Void> {
		return cacheClient.delete(key: MoviesCache.keys.identifier, value: id)
	}

	func get<V>(where key: String, equals value: V) -> Observable<[Movie]> {
		return cacheClient.get(key: key, value: value)
	}

	func createOrUpdate(movie: Movie) -> Observable<Void> {
		return cacheClient.createOrUpdate(element: movie)
	}
}
