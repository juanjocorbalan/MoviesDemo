import Foundation
import CoreData

extension CDMovie: DomainConvertibleEntity {
	
	func toDomain() -> Movie {
		return Movie(identifier: identifier ?? "",
					 originalTitle: title ?? "",
					 releaseDate: releaseDate ?? "",
					 voteAverage: voteAverage,
					 overview: overview ?? "",
					 posterPath: poster ?? "",
					 year: year ?? "")
	}
}

extension Movie: ManagedConvertibleEntity {
	
	func toManaged() -> CDMovie {
		let movie = CDMovie(context: CoreDataStack.shared.context)
		movie.identifier = identifier
		movie.title = originalTitle
		movie.releaseDate = releaseDate
		movie.voteAverage = voteAverage
		movie.poster = posterPath
		movie.overview = overview
		movie.year = year
		return movie
	}
}
