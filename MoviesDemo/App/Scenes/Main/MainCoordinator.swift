import UIKit
import RxSwift

class MainCoordinator: Coordinator<Void> {
	
	private let window: UIWindow
	
	init(window: UIWindow) {
		self.window = window
	}
	
	override func start() -> Observable<Void> {
		let coordinator = MovieListCoordinator(window: window)
		return run(coordinator)
	}
}
