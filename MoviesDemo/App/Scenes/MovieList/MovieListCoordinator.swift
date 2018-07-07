import UIKit
import RxSwift
import SafariServices

class MovieListCoordinator: Coordinator<Void> {
	
	private let window: UIWindow
	
	init(window: UIWindow) {
		self.window = window
	}
	
	// MARK: - Creation

	override func start() -> Observable<Void> {
		let viewController: MovieListViewController = SceneAssembler().resolve(year: "2018")
		let navigationController = UINavigationController(rootViewController: viewController)
		
		viewController.viewModel.showMovie
			.subscribe(onNext: { [weak self] in
				_ = self?.showMovie(by: $0, in: navigationController)
			})
			.disposed(by: disposeBag)

		viewController.viewModel.showFilterList
			.flatMap { [weak self] _ -> Observable<String?> in
				guard let strongSelf = self else { return Observable.empty() }
				return strongSelf.showFilterList(on: navigationController)
			}
			.filter { $0 != nil }
			.subscribe(onNext: { year in
				viewController.viewModel.setFilter.onNext(year!)
			})
			.disposed(by: disposeBag)
		
		self.window.rootViewController = navigationController
		self.window.makeKeyAndVisible()
		
		return Observable.never()
	}
	
	// MARK: - Navigation
	
	private func showMovie(by id: String, in navigationController: UINavigationController) -> Observable<Void>{
		let coordinator = MovieDetailCoordinator(movieId: id,
												 navigationController: navigationController)
		return run(coordinator)
	}
	
	private func showFilterList(on rootViewController: UIViewController) -> Observable<String?> {
		let coordinator = FilterListCoordinator(rootViewController: rootViewController)
		return run(coordinator)
	}
}
