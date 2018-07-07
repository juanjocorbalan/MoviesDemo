import UIKit
import RxSwift

class FilterListCoordinator: Coordinator<String?> {
	
	private let rootViewController: UIViewController
	
	init(rootViewController: UIViewController) {
		self.rootViewController = rootViewController
	}
	
	override func start() -> Observable<String?> {
	
		let viewController: FilterListViewController = SceneAssembler().resolve()
		let navigationController = UINavigationController(rootViewController: viewController)
		
		let cancel = viewController.viewModel.didCancel.map { _ in Optional<String>(nilLiteral: ()) }
		let year = viewController.viewModel.didSelect.map { Optional($0) }
		
		rootViewController.present(navigationController, animated: true)
		
		return Observable.merge(cancel, year)
			.take(1)
			.do(onNext: { [weak self] _ in self?.rootViewController.dismiss(animated: true) })
	}
}
