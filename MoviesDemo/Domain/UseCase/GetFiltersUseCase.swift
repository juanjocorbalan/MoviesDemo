import Foundation
import RxSwift

// USE CASE to get from service the year list to filter movies

class GetFiltersUseCase {
	let movieService: MovieServiceType
	
	init(movieService: MovieServiceType) {
		self.movieService = movieService
	}
	
	func execute() -> Observable<[String]> {
		return movieService.getFilters()
	}
}
