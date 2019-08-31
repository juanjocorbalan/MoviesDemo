import Foundation
import RxSwift

// USE CASE to get from service the year list to filter movies

class GetFiltersUseCase {
	private let movieRepository: MovieRepositoryType
	
	init(movieRepository: MovieRepositoryType) {
		self.movieRepository = movieRepository
	}
	
	func execute() -> Observable<[String]> {
		return movieRepository.getFilters()
	}
}
