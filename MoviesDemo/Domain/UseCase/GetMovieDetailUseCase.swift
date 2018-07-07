import Foundation
import RxSwift

// USE CASE to get a movie detail from service

class GetMovieDetailUseCase {
	let movieService: MovieServiceType
	
	init(movieService: MovieServiceType) {
		self.movieService = movieService
	}
	
	func execute(with id: String) -> Observable<Movie> {
		return movieService.getMovieDetail(by: id)
	}
}
