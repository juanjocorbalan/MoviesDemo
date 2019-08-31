import Foundation
import RxSwift

@testable import MoviesDemo

class MovieCacheClientFake: RealmClient<Movie> {
	
}

class MovieAPIClientFake: APIClient {
    
    override func execute<R>(_ resource: R) -> Observable<R.ResponseType> where R: ResourceType, R.ResponseType == MovieResultsDto {
        guard let movieResults: MovieResultsDto = decodeJSONFile(named: "movieResults")
            else { return Observable<R.ResponseType>.error(APIError.serialization) }
        return Observable.just(movieResults)
    }
}

class MovieApiDataSourceFake: MoviesApiDataSource {
	
	init() {
		super.init(apiClient: MovieAPIClientFake())
	}
}

class MovieCacheDataSourceFake: MoviesCacheDataSource<MovieCacheClientFake> {

	init() {
		super.init(cacheClient: MovieCacheClientFake())
	}
}

class MovieRepositoryFake: MovieRepository {
	
	init() {
		super.init(apiDataSource: MovieApiDataSourceFake(),
				   cacheDataSource: MovieCacheDataSourceFake())
	}
}

class GetMoviesUseCaseFake: GetMoviesUseCase {
	
	init() {
		super.init(movieRepository: MovieRepositoryFake())
	}
}
