import RxSwift
import RealmSwift

class RealmClient<T: RealmConvertibleEntity>: CacheClientType where T.RealmEntity: Object, T == T.RealmEntity.DomainEntity {
	
	private let realm: Realm
	
	init(configuration: Realm.Configuration = Realm.Configuration(inMemoryIdentifier: "cache")) {
		self.realm = try! Realm(configuration: configuration)
	}
	
	//MARK: - Get
	
	func getAll() -> Observable<[T]> {
		return get()
	}
	
	func get(quantity: Int? = nil, orderedBy key: String? = nil, ascending: Bool? = false) -> Observable<[T]> {
	
		return Observable.create { observer in
			
			var sortDescriptors: [SortDescriptor] = []
			if let keyPath = key, let ascending = ascending {
				sortDescriptors = [SortDescriptor(keyPath: keyPath, ascending: ascending)]
			}
	
			let results = self.realm.objects(T.RealmEntity.self)
				.sorted(by: sortDescriptors)
			
			var array: [T.RealmEntity] = Array(results)
			if let quantity = quantity, quantity <= results.count {
				array = Array(results[0..<quantity])
			}

			observer.onNext(array.map { $0.toDomain() })
			observer.onCompleted()
			return Disposables.create()
		}
	}
	
	func get<V>(key: String, value: V) -> Observable<[T]> {
		
		return Observable.create { [weak self] observer in
			
			guard let strongSelf = self else {
				observer.onError(CacheError.error)
				return Disposables.create()
			}
			
			let results = strongSelf.realm.objects(T.RealmEntity.self)
				.filter(NSPredicate(format: "\(key) == %@", value as! CVarArg))
			
			observer.onNext(results.map { $0.toDomain() })
			observer.onCompleted()

			return Disposables.create()
		}
	}
	
	//MARK: - Create/Update
	
	func createOrUpdate(element: T) -> Observable<Void> {
	
		return Observable.create { [weak self] observer in
			
			guard let strongSelf = self else {
				observer.onError(CacheError.error)
				return Disposables.create()
			}
			
			do {
				try strongSelf.realm.write {
					strongSelf.realm.add(element.toRealm(), update: true)
				}
				observer.onNext(())
				observer.onCompleted()
			} catch {
				observer.onError(CacheError.error)
			}
			
			return Disposables.create()
		}
	}
	
	//MARK: - Remove
	
	func delete<V>(key: String, value: V) -> Observable<Void> {
	
		return Observable.create { [weak self] observer in
		
			guard let strongSelf = self else {
				observer.onError(CacheError.error)
				return Disposables.create()
			}
			
			let results = strongSelf.realm.objects(T.RealmEntity.self)
				.filter(NSPredicate(format: "K == %@", key, value as! CVarArg))

			if !results.isEmpty {
				do {
					try strongSelf.realm.write {
						strongSelf.realm.delete(results[0])
					}
					observer.onNext(())
					observer.onCompleted()
				} catch {
					observer.onError(CacheError.error)
				}
			} else {
				observer.onError(CacheError.notFound)
			}
			
			return Disposables.create()
			}.catchError { error in
				return Observable.error(CacheError.error)
		}
	}
	
	func deleteAll() -> Observable<Void> {
		
		return Observable.create { [weak self] observer in
			
			guard let strongSelf = self else {
				observer.onError(CacheError.error)
				return Disposables.create()
			}
			
			let results = strongSelf.realm.objects(T.RealmEntity.self)

			if !results.isEmpty {
				do {
					try strongSelf.realm.write {
						strongSelf.realm.delete(results)
					}
					observer.onNext(())
					observer.onCompleted()
				} catch {
					observer.onError(CacheError.error)
				}
			} else {
				observer.onNext(())
				observer.onCompleted()
			}
			
			return Disposables.create()
			}.catchError { error in
				return Observable.error(CacheError.error)
		}
	}
}
