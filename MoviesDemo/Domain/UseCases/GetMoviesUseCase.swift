import Foundation
import RxSwift

// USE CASE to get movies list from service

class GetMoviesUseCase {
	private let movieRepository: MovieRepositoryType
	
	init(movieRepository: MovieRepositoryType) {
		self.movieRepository = movieRepository
	}
	
	func execute(with year: String) -> Observable<[Movie]> {
		return movieRepository.getTopMovies(by: year)
	}
}
