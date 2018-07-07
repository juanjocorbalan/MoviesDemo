import RxSwift
import CoreData

class CoreDataClient<T: ManagedConvertibleEntity> where T.ManagedEntity: NSManagedObject, T == T.ManagedEntity.DomainEntity {
	
	private let stack: CoreDataStack
	
	private var context: NSManagedObjectContext {
		return self.stack.context
	}
	
	private var request: NSFetchRequest<T.ManagedEntity>
	
	init(coreDataStack: CoreDataStack = CoreDataStack.shared) {
		self.stack = coreDataStack
		self.request = T.ManagedEntity.fetchRequest() as! NSFetchRequest<T.ManagedEntity>
	}
	
	//MARK: - Get
	
	func getAll() -> Observable<[T]> {
		return get()
	}
	
	func get(quantity: Int? = nil, orderedBy key: String? = nil, ascending: Bool? = false) -> Observable<[T]> {
		
		return Observable.create { [weak self] observer in
			
			guard let strongSelf = self else {
				observer.onError(CacheError.error)
				return Disposables.create()
			}
			
			if let keyPath = key, let ascending = ascending {
				strongSelf.request.sortDescriptors = [NSSortDescriptor(key: keyPath, ascending: ascending)]
			}
			
			do {
				var results = try strongSelf.context.fetch(strongSelf.request)
				if let quantity = quantity, quantity <= results.count {
					results = Array(results[0..<quantity])
				}
				
				observer.onNext(results.map { $0.toDomain() })
				observer.onCompleted()
 
			} catch(let error) {
				observer.onError(error)
			}
			
			return Disposables.create()
		}
	}
	
	func get<V>(key: String, value: V) -> Observable<[T]> {
		
		return Observable.create { [weak self] observer in
			
			guard let strongSelf = self else {
				observer.onError(CacheError.error)
				return Disposables.create()
			}
			
			strongSelf.request.predicate = NSPredicate(format: "\(key) == %@", value as! CVarArg)

			do {
				let results = try strongSelf.context.fetch(strongSelf.request)
				
				observer.onNext(results.map { $0.toDomain() })
				observer.onCompleted()
				
			} catch {
				observer.onError(CacheError.error)
			}
			
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
			
			strongSelf.context.insert(element.toManaged())

			do {
				try strongSelf.context.save()
	
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
			
			strongSelf.request.predicate = NSPredicate(format: "\(key) == %@", value as! CVarArg)
			
			do {
				let results = try strongSelf.context.fetch(strongSelf.request)

				if let element = results.first {
					strongSelf.context.delete(element)
					
					try strongSelf.context.save()

					observer.onNext(())
					observer.onCompleted()
				} else {
					observer.onError(CacheError.notFound)
				}
			} catch {
				observer.onError(CacheError.error)
			}

			return Disposables.create()
		}
	}
	
	func deleteAll() -> Observable<Void> {
		
		return Observable.create { [weak self] observer in
			
			guard let strongSelf = self else {
				observer.onError(CacheError.error)
				return Disposables.create()
			}
			
			do {
				let results = try strongSelf.context.fetch(strongSelf.request)
				
				results.forEach {
					strongSelf.context.delete($0)
				}
				
				try strongSelf.context.save()
				
				observer.onNext(())
				observer.onCompleted()
			} catch {
				observer.onError(CacheError.error)
			}

			return Disposables.create()
		}
	}
}
