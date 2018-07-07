import Foundation
import RxSwift

@testable import MoviesDemo

class CacheclientMovieFake: RealmClient<Movie> {
	
}

class APIClientMovieFake: APIClient<Movie> {
	
}

class APIClientMovieResultsFake: APIClient<MovieResults> {

	override func getItem(forResource resource: ResourceType) -> Observable<MovieResults> {
		let json = getJSONDictionaryFromFile(named: "movieResults", inBundle: .main)
		let movieResults = MovieResults(dictionary: json)
		return Observable.just(movieResults!)
	}
}

class MoviesApiRepositoryFake: MoviesApiRepository {
	
	init() {
		super.init(movieApiClient: APIClientMovieFake(), movieResultsApiClient: APIClientMovieResultsFake())
	}
}

class MoviesCacheRepositoryFake: MoviesCacheRepository<CacheclientMovieFake> {

	init() {
		super.init(cacheClient: CacheclientMovieFake())
	}
}

class MovieServiceFake: MovieService {
	
	init() {
		super.init(apiRepository: MoviesApiRepositoryFake(),
				   cacheRepository: MoviesCacheRepositoryFake())
	}
}

class GetMoviesUseCaseFake: GetMoviesUseCase {
	
	init() {
		super.init(movieService: MovieServiceFake())
	}
}
