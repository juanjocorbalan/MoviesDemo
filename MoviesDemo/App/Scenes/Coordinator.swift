import RxSwift
import Foundation

class Coordinator<T> {
	
	let disposeBag = DisposeBag()
	
	private let identifier = UUID()
	private var coordinators = [UUID: Any]()
	
	func start() -> Observable<T> {
		fatalError("Start method should be implemented")
	}

	func run<T>(_ coordinator: Coordinator<T>) -> Observable<T> {
		add(coordinator: coordinator)
		return coordinator.start()
			.do(onNext: { [weak self] _ in
				self?.remove(coordinator: coordinator)
			})
	}

	// MARK: - Private methods
	
	private func add<T>(coordinator: Coordinator<T>) {
		coordinators[coordinator.identifier] = coordinator
	}
	
	private func remove<T>(coordinator: Coordinator<T>) {
		coordinators[coordinator.identifier] = nil
	}
}
