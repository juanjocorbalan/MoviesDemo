import UIKit
import RxSwift
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	private var mainCoordinator: MovieListCoordinator!
    private var dependencies = DependencyContainer()
	private let disposeBag = DisposeBag()
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		window = UIWindow()
		
        mainCoordinator = MovieListCoordinator(window: window!, dependencies: dependencies)
		mainCoordinator.start()
			.subscribe()
			.disposed(by: disposeBag)
		
		return true
	}
}
