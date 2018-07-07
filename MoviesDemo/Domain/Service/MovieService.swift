import Foundation
import RxSwift

protocol MovieServiceType {
	func getTopMovies(by year: String) -> Observable<[Movie]>
	func getMovieDetail(by id: String) -> Observable<Movie>
	func getFilters() -> Observable<[String]>
}

class MovieService: MovieServiceType {
	
	private let apiRepository: MoviesApiRepositoryType
	private let cacheRepository: MoviesCacheRepositoryType
	private let disposeBag = DisposeBag()
	
	init(apiRepository: MoviesApiRepositoryType, cacheRepository: MoviesCacheRepositoryType) {
		self.apiRepository = apiRepository
		self.cacheRepository = cacheRepository
	}
	
	func getTopMovies(by year: String) -> Observable<[Movie]> {
		
		let apiMoviesObservable = apiRepository.getMovies(by: year)
			.observeOn(MainScheduler.instance)
			.flatMap({ [weak self] movies -> Observable<[Movie]> in
				guard let strongSelf = self else { return Observable.just(movies) }
				movies.forEach {
					strongSelf.cacheRepository
						.createOrUpdate(movie: $0)
						.subscribe()
						.disposed(by: strongSelf.disposeBag)
				}
				return Observable.just(movies)
			})
		
		return Observable.merge(cacheRepository.get(where: MovieKeys.year, equals: year), apiMoviesObservable)
			.map { movies in
				return movies.map { movie in
					if !movie.posterPath.isEmpty {
						var movie = movie
						movie.posterPath = MoviesAPI.baseImagesURL + movie.posterPath
						return movie
					}
					else  {
						return movie
					}
				}
		}
	}

	func getMovieDetail(by id: String) -> Observable<Movie> {
		return apiRepository.getMovie(by: id)
			.map {
				var movie = $0
				movie.posterPath = MoviesAPI.baseImagesURL + movie.posterPath
				return movie
		}
	}

	func getFilters() -> Observable<[String]> {
		return Observable.just(["2018", "2017", "2016", "2015", "2014"])
	}
}
