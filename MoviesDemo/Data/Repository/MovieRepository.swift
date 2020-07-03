import Foundation
import RxSwift

class MovieRepository: MovieRepositoryType {
	
	private let apiDataSource: MoviesApiDataSourceType
	private let cacheDataSource: MoviesCacheDataSourceType
	private let disposeBag = DisposeBag()
	
	init(apiDataSource: MoviesApiDataSourceType, cacheDataSource: MoviesCacheDataSourceType) {
		self.apiDataSource = apiDataSource
		self.cacheDataSource = cacheDataSource
	}
	
	func getTopMovies(by year: String) -> Observable<[Movie]> {
		
		let apiMoviesObservable = apiDataSource.getMovies(by: year)
			.observeOn(MainScheduler.instance)
			.flatMap({ [weak self] movies -> Observable<[Movie]> in
				guard let strongSelf = self else { return Observable.just(movies) }
				movies.forEach {
					strongSelf.cacheDataSource
						.createOrUpdate(movie: $0)
						.subscribe()
						.disposed(by: strongSelf.disposeBag)
				}
				return Observable.just(movies)
			})
		
		return Observable.merge(cacheDataSource.get(where: MovieKeys.year, equals: year), apiMoviesObservable)
			.map { movies in
				return movies.map { movie in
					if !movie.posterPath.isEmpty {
						var movie = movie
						movie.posterPath = MoviesAPI.baseImagesURL + movie.posterPath
						return movie
					} else  {
						return movie
					}
				}
		}
	}

	func getMovieDetail(by id: String) -> Observable<Movie> {
		return apiDataSource.getMovie(by: id)
			.map {
				var movie = $0
				movie.posterPath = MoviesAPI.baseImagesURL + movie.posterPath
				return movie
            }
	}

	func getFilters() -> Observable<[String]> {
        let currentYear = Calendar.current.component(.year, from: Date())
        return Observable.just((2014...currentYear).reversed().map({ String($0) }))
	}
}
