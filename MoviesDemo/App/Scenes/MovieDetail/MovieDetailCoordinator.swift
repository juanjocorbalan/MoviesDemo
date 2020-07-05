import UIKit
import RxSwift

class MovieDetailCoordinator: Coordinator<Void> {
	
	private let navigationController: UINavigationController
	private let movieId: String
    private let dependencies: DependencyContainer
	
    init(movieId: String, navigationController: UINavigationController, dependencies: DependencyContainer) {
		self.navigationController = navigationController
		self.movieId = movieId
        self.dependencies = dependencies
	}
	
	override func start() -> Observable<Void> {
		
		let viewController: MovieDetailViewController = dependencies.resolve(movieId: movieId)
				
		navigationController.pushViewController(viewController, animated: true)
		
        return viewController.rx.deallocated
	}
}
