import UIKit

class MovieCell: UICollectionViewCell {
    
	@IBOutlet weak var imageView: UIImageView!
	
	override func prepareForReuse() {
		super.prepareForReuse()
		imageView.image = nil
	}
	
	func setup(with viewModel: MovieCellViewModel) {
		guard let posterURL = viewModel.poster else { return }
		imageView.with(url: posterURL)
	}
}
