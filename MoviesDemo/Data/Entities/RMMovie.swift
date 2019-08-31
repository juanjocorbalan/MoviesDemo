import Foundation
import RealmSwift

class RMMovie: Object {
	@objc dynamic var identifier: String = ""
	@objc dynamic var originalTitle: String = ""
	@objc dynamic var releaseDate: String = ""
	@objc dynamic var voteAverage: Double = 0.0
	@objc dynamic var overview: String = ""
	@objc dynamic var posterPath: String = ""
	@objc dynamic var year: String = ""

	override class func primaryKey() -> String {
		return "identifier"
	}
}

extension RMMovie: DomainConvertibleEntity {

	func toDomain() -> Movie {
		return Movie(identifier: identifier,
					 originalTitle: originalTitle,
					 releaseDate: releaseDate,
					 voteAverage: voteAverage,
					 overview: overview,
					 posterPath: posterPath,
					 year: year)
	}
}

extension Movie: RealmConvertibleEntity {
	
	func toRealm() -> RMMovie {
		let movie = RMMovie()
		movie.identifier = identifier
		movie.originalTitle = originalTitle
		movie.releaseDate = releaseDate
		movie.voteAverage = voteAverage
		movie.posterPath = posterPath
		movie.overview = overview
		movie.year = year
		return movie
	}
}
