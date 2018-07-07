import UIKit
import RxSwift
import RxCocoa

class FilterListViewController: UIViewController, StoryboardInitializable {
	
	private let disposeBag = DisposeBag()
	var viewModel: FilterListViewModel!
	
	@IBOutlet weak var tableView: UITableView!
	private let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
		setupBindings()
	}
	
	private func setupUI() {
		navigationItem.leftBarButtonItem = cancelButton
	}
	
	private func setupBindings() {
		
		viewModel.items
			.bind(to: tableView.rx.items(cellIdentifier: "FilterCell",
										 cellType: UITableViewCell.self)) { (_, year, cell) in
				cell.textLabel?.text = year
				cell.selectionStyle = .none
			}
			.disposed(by: disposeBag)
		
		tableView.rx.modelSelected(String.self)
			.bind(to: viewModel.itemSelected)
			.disposed(by: disposeBag)
		
		cancelButton.rx.tap
			.bind(to: viewModel.cancelled)
			.disposed(by: disposeBag)
	}
}
