import Foundation
import RealmSwift

struct Movie {
	let identifier: String
	let originalTitle: String
	let releaseDate: String
	let voteAverage: Double
	let overview: String
	var posterPath: String
	var year: String
}

extension Movie: JSONDecodable {
	init?(dictionary json: JSONDictionary) {
		guard
			let identifier = json[MovieKeys.id] as? Int,
			let originalTitle = json[MovieKeys.title] as? String,
			let releaseDate = json[MovieKeys.releaseDate] as? String,
			let voteAverage = json[MovieKeys.voteAverage] as? NSNumber,
			let overview = json[MovieKeys.overview] as? String
			else { return nil }
		
		self.init(identifier: "\(identifier)",
				  originalTitle: originalTitle,
				  releaseDate: releaseDate,
				  voteAverage: voteAverage.doubleValue,
				  overview: overview,
				  posterPath: json[MovieKeys.poster] as? String ?? "",
				  year: "")
	}
}
