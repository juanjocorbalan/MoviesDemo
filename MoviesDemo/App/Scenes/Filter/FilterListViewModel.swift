import RxSwift

struct FilterListViewModel {
	
	// MARK: - Inputs
	
	let itemSelected: AnyObserver<String>
	let cancelled: AnyObserver<Void>
	
	// MARK: - Outputs
	
	let items: Observable<[String]>
	let didSelect: Observable<String>
	let didCancel: Observable<Void>
	
	init(getFilterListUseCase: GetFiltersUseCase) {

		self.items = getFilterListUseCase.execute()
		
		let _itemSelected = PublishSubject<String>()
		self.itemSelected = _itemSelected.asObserver()
		self.didSelect = _itemSelected.asObservable()
		
		let _cancelled = PublishSubject<Void>()
		self.cancelled = _cancelled.asObserver()
		self.didCancel = _cancelled.asObservable()
	}
}
