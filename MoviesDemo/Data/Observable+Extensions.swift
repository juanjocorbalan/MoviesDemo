import Foundation
import RxSwift

extension Sequence where Iterator.Element: DomainConvertibleEntity {
    func toDomain() -> [Iterator.Element.DomainEntity] {
        return map {
            return $0.toDomain()
        }
    }
}
