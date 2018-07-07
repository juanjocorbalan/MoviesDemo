import UIKit
import RxSwift
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	private var mainCoordinator: MainCoordinator!
	private let disposeBag = DisposeBag()
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

		window = UIWindow()
		
		mainCoordinator = MainCoordinator(window: window!)
		mainCoordinator.start()
			.subscribe()
			.disposed(by: disposeBag)
		
		return true
	}
}
