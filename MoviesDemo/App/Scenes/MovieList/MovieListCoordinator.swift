import UIKit
import RxSwift
import SafariServices

class MovieListCoordinator: Coordinator<Void> {
	
	private let window: UIWindow
    private let dependencies: DependencyContainer
	
    init(window: UIWindow, dependencies: DependencyContainer) {
		self.window = window
        self.dependencies = dependencies
	}
	
	// MARK: - Creation

	override func start() -> Observable<Void> {
        let currentYear = Calendar.current.component(.year, from: Date())
		let viewController: MovieListViewController = dependencies.resolve(year: String(currentYear))
		let navigationController = UINavigationController(rootViewController: viewController)
		
		viewController.viewModel.showMovie
            .flatMap { [weak self] movieId -> Observable<Void> in
                guard let strongSelf = self else { return Observable.empty() }
                return strongSelf.showMovie(movieId, in: navigationController)
            }
			.subscribe()
			.disposed(by: disposeBag)

		viewController.viewModel.showFilterList
			.flatMap { [weak self] _ -> Observable<String?> in
				guard let strongSelf = self else { return Observable.empty() }
				return strongSelf.showFilterList(on: navigationController)
			}
			.filter { $0 != nil }
            .map { $0! }
            .bind(to: viewController.viewModel.setFilter)
			.disposed(by: disposeBag)
		
		self.window.rootViewController = navigationController
		self.window.makeKeyAndVisible()
		
		return Observable.never()
	}
	
	// MARK: - Navigation
	
 	private func showMovie(_ id: String, in navigationController: UINavigationController) -> Observable<Void>{
		let coordinator = MovieDetailCoordinator(movieId: id,
												 navigationController: navigationController,
                                                 dependencies: dependencies)
		return run(coordinator)
	}
	
	private func showFilterList(on rootViewController: UIViewController) -> Observable<String?> {
		let coordinator = FilterListCoordinator(rootViewController: rootViewController,
                                                dependencies: dependencies)
		return run(coordinator)
	}
}
