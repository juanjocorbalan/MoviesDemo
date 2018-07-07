import UIKit
import RxSwift

class MovieDetailCoordinator: Coordinator<Void> {
	
	private let navigationController: UINavigationController
	private let movieId: String
	
	init(movieId: String, navigationController: UINavigationController) {
		self.navigationController = navigationController
		self.movieId = movieId
	}
	
	override func start() -> Observable<Void> {
		
		let viewController: MovieDetailViewController = SceneAssembler().resolve(movieId: movieId)
				
		navigationController.pushViewController(viewController, animated: true)
		
		return Observable.never()
	}
}
