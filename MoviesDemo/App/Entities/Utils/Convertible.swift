import Foundation

protocol DomainConvertibleEntity {
	associatedtype DomainEntity
	
	func toDomain() -> DomainEntity
}

protocol RealmConvertibleEntity {
	associatedtype RealmEntity: DomainConvertibleEntity
	
	func toRealm() -> RealmEntity
}

protocol ManagedConvertibleEntity {
	associatedtype ManagedEntity: DomainConvertibleEntity
	
	func toManaged() -> ManagedEntity
}
