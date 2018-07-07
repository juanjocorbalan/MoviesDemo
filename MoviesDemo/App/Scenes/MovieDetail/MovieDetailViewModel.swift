import RxSwift

struct MovieDetailViewModel {
	
	// MARK: - Inputs
	
	
	// MARK: - Outputs
	
	let title: Observable<String>
	let releaseDate: Observable<String>
	let voteAverage: Observable<String>
	let overview: Observable<String>
	let poster: Observable<URL?>
	let errorMessage: Observable<String>
	let isLoading: Observable<Bool>

	init(movieId: String, getMovieDetailUseCase: GetMovieDetailUseCase) {

		let _errorMessage = PublishSubject<String>()
		self.errorMessage = _errorMessage.asObservable()

		let movie = getMovieDetailUseCase.execute(with: movieId).share()
			.catchError { error in
				_errorMessage.onNext(error.localizedDescription)
				return Observable.empty()
			}

		self.isLoading = movie.map { _ in return false}.startWith(true)
		
		self.title = movie.map { $0.originalTitle }
		self.releaseDate = movie.map { $0.releaseDate }
		self.voteAverage = movie.map { "\($0.voteAverage)" }
		self.overview = movie.map { $0.overview }
		self.poster = movie.map { URL(string: $0.posterPath) }
	}
}
