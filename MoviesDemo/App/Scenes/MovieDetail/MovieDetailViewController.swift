import UIKit
import RxSwift
import RxCocoa

class MovieDetailViewController: UIViewController, StoryboardInitializable {
	
	private let disposeBag = DisposeBag()

	var viewModel: MovieDetailViewModel!
	
	@IBOutlet weak var loadingView: UIView!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var releaseDateLabel: UILabel!
	@IBOutlet weak var voteLabel: UILabel!
	@IBOutlet weak var overviewTextView: UITextView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupBindings()
	}
	
	private func setupBindings() {
		
		viewModel.title
			.observeOn(MainScheduler.instance)
			.bind(to: titleLabel.rx.text)
			.disposed(by: disposeBag)

		viewModel.voteAverage
			.observeOn(MainScheduler.instance)
			.bind(to: voteLabel.rx.text)
			.disposed(by: disposeBag)

		viewModel.releaseDate
			.observeOn(MainScheduler.instance)
			.bind(to: releaseDateLabel.rx.text)
			.disposed(by: disposeBag)

		viewModel.overview
			.observeOn(MainScheduler.instance)
			.bind(to: overviewTextView.rx.text)
			.disposed(by: disposeBag)
		
		viewModel.poster
			.observeOn(MainScheduler.instance)
			.filter { $0 != nil }
			.subscribe(onNext: { url in
				self.imageView.with(url: url!)
			})
			.disposed(by: disposeBag)
		
		viewModel.isLoading
			.map { !$0 }
			.bind(to: loadingView.rx.isHidden)
			.disposed(by: disposeBag)

		viewModel.errorMessage
			.subscribe(onNext: { [weak self] in self?.showError(message: $0) })
			.disposed(by: disposeBag)
	}
}
