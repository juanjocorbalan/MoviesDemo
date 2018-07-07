import Foundation
import RxSwift

// USE CASE to get movies list from service

class GetMoviesUseCase {
	let movieService: MovieServiceType
	
	init(movieService: MovieServiceType) {
		self.movieService = movieService
	}
	
	func execute(with year: String) -> Observable<[Movie]> {
		return movieService.getTopMovies(by: year)
	}
}
