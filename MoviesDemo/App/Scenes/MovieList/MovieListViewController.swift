import UIKit
import RxSwift
import RxCocoa

class MovieListViewController: UIViewController, StoryboardInitializable {
	
	@IBOutlet weak var loadingView: UIView!
	@IBOutlet weak var collectionView: UICollectionView!

	private let disposeBag = DisposeBag()
	private let refreshControl = UIRefreshControl()
	private let filtersButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
																 target: nil,
																 action: nil)

	var viewModel: MovieListViewModel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
		setupBindings()
		
		refreshControl.sendActions(for: .valueChanged)
	}
	
	private func setupUI() {
		collectionView.refreshControl = refreshControl
		navigationItem.rightBarButtonItem = filtersButton
	}
	
	private func setupBindings() {
		
		viewModel.title
			.bind(to: self.rx.title)
			.disposed(by: disposeBag)

		viewModel.movies
			.do(onNext: { [weak self] _ in
				self?.refreshControl.endRefreshing()
				self?.collectionView.setContentOffset(.zero, animated: false)
			})
			.bind(to: collectionView.rx.items(cellIdentifier: "MovieCell", cellType: MovieCell.self)) { (_, viewModel, cell) in
				cell.setup(with: viewModel)
			}
			.disposed(by: disposeBag)
		
		viewModel.errorMessage
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { [weak self] in
				self?.refreshControl.endRefreshing()
				self?.showError(message: $0)
			})
			.disposed(by: disposeBag)
		
		viewModel.isLoading
			.map { !$0 }
			.bind(to: loadingView.rx.isHidden)
			.disposed(by: disposeBag)

		refreshControl.rx.controlEvent(.valueChanged)
			.bind(to: viewModel.reload)
			.disposed(by: disposeBag)
		
		filtersButton.rx.tap
			.bind(to: viewModel.filterChoosen)
			.disposed(by: disposeBag)
		
		collectionView.rx.modelSelected(MovieCellViewModel.self)
			.bind(to: viewModel.movieSelected)
			.disposed(by: disposeBag)
		
		collectionView.rx.setDelegate(self)
			.disposed(by: disposeBag)
	}
}

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						sizeForItemAt indexPath: IndexPath) -> CGSize {
		let columnWidth = (collectionView.frame.size.width - 30) / 2.0
			return CGSize(width: columnWidth, height: columnWidth * 1.55)
	}
}
