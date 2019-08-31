import UIKit

extension UIViewController {
	
	func showError(message: String) {
		let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		present(alertController, animated: true)
	}
}

