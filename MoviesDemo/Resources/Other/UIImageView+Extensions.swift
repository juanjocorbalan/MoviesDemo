import UIKit

extension UIImageView {
	
	func with(url: URL) {
		
		URLSession.shared.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
			
			guard let data = data, error == nil, response?.url == url else { return }
			
			DispatchQueue.main.async {
				self.image = UIImage(data: data)
			}
		}).resume()
	}
}
