import Foundation
import RxSwift

// USE CASE to get a movie detail from service

class GetMovieDetailUseCase {
	private let movieRepository: MovieRepositoryType
	
	init(movieRepository: MovieRepositoryType) {
		self.movieRepository = movieRepository
	}
	
	func execute(with id: String) -> Observable<Movie> {
		return movieRepository.getMovieDetail(by: id)
	}
}
