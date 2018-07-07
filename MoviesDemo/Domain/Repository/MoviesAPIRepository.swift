import Foundation
import RxSwift

protocol MoviesApiRepositoryType {
	func getMovie(by id: String) -> Observable<Movie>
	func getMovies(by year: String) -> Observable<[Movie]>
}

class MoviesApiRepository<MovieClient, ResultsClient>: MoviesApiRepositoryType where MovieClient: APIClientType, ResultsClient: APIClientType, MovieClient.T == Movie, ResultsClient.T == MovieResults {
	
	private let movieApiClient: MovieClient
	private let movieResultsApiClient: ResultsClient

	init(movieApiClient: MovieClient, movieResultsApiClient: ResultsClient) {
		self.movieApiClient = movieApiClient
		self.movieResultsApiClient = movieResultsApiClient
	}

	func getMovie(by id: String) -> Observable<Movie> {

		var url = MoviesAPI.baseURL.appendingPathComponent(MoviesAPI.paths.movie)
		url.appendPathComponent(id)

		let parameters = [MoviesAPI.query.key: MoviesAPI.key]

		let resource = Resource(url: url, parameters: parameters)
		
		return movieApiClient.getItem(forResource: resource)
	}
	
	func getMovies(by year: String) -> Observable<[Movie]> {
		
		var url = MoviesAPI.baseURL.appendingPathComponent(MoviesAPI.paths.discover)
		url.appendPathComponent(MoviesAPI.paths.movie)
		
		let parameters = [MoviesAPI.query.key: MoviesAPI.key,
						  MoviesAPI.query.sort: MoviesAPI.query.popularity,
						  MoviesAPI.query.year: year]
		
		let resource = Resource(url: url, parameters: parameters)
		
		return movieResultsApiClient.getItem(forResource: resource)
			.map { $0.results
				.map { movie in
					var movie = movie
					movie.year = year
					return movie
				}
		}
	}
}
