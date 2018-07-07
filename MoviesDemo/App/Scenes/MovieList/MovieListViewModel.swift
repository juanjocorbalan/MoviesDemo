import Foundation
import RxSwift

struct MovieListViewModel {
	
	// MARK: - Inputs
	
	let setFilter: AnyObserver<String>
	let filterChoosen: AnyObserver<Void>
	let movieSelected: AnyObserver<MovieCellViewModel>
	let reload: AnyObserver<Void>
	
	// MARK: - Outputs
	
	let title: Observable<String>
	let movies: Observable<[MovieCellViewModel]>
	let showMovie: Observable<String>
	let showFilterList: Observable<Void>
	let errorMessage: Observable<String>
	let isLoading: Observable<Bool>

	init(initialYear: String, getMovieListUseCase: GetMoviesUseCase) {
		
		let _reload = PublishSubject<Void>()
		self.reload = _reload.asObserver()
		
		let _currentFilter = BehaviorSubject<String>(value: initialYear)
		self.setFilter = _currentFilter.asObserver()
		
		self.title = _currentFilter.asObservable().map { "\($0) Top Movies" }
		
		let _errorMessage = PublishSubject<String>()
		self.errorMessage = _errorMessage.asObservable()
		
		let _shouldLoad = Observable.combineLatest( _reload, _currentFilter) { $1 }

		self.movies = _shouldLoad.flatMapLatest { year in
			getMovieListUseCase.execute(with: year)
				.catchError { error in
					_errorMessage.onNext(error.localizedDescription)
					return Observable.empty()
				}
			}
			.map { $0.map(MovieCellViewModel.init) }
		
		self.isLoading = Observable.merge(_shouldLoad.map { _ in true },
										  errorMessage.map { _ in false },
										  movies.map { movies in movies.count == 0 })

		let _movieSelected = PublishSubject<MovieCellViewModel>()
		self.movieSelected = _movieSelected.asObserver()
		self.showMovie = _movieSelected.asObservable().map { $0.identifier }
		
		let _filterChoosen = PublishSubject<Void>()
		self.filterChoosen = _filterChoosen.asObserver()
		self.showFilterList = _filterChoosen.asObservable()
	}
}
