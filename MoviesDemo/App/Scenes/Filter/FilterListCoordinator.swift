import UIKit
import RxSwift

class FilterListCoordinator: Coordinator<String?> {
	
	private let rootViewController: UIViewController
    private let dependencies: DependencyContainer
	
    init(rootViewController: UIViewController, dependencies: DependencyContainer) {
		self.rootViewController = rootViewController
        self.dependencies = dependencies
	}
	
	override func start() -> Observable<String?> {
	
		let viewController: FilterListViewController = dependencies.resolve()
		let navigationController = UINavigationController(rootViewController: viewController)
		
		let cancel = viewController.viewModel.didCancel.map { _ in Optional<String>(nilLiteral: ()) }
		let year = viewController.viewModel.didSelect.map { Optional($0) }
		
		rootViewController.present(navigationController, animated: true)
		
		return Observable.merge(cancel, year)
			.take(1)
			.do(onNext: { [weak self] _ in self?.rootViewController.dismiss(animated: true) })
	}
}
