import Foundation

struct MovieResults {
	let page: Int
	let total_pages: Int
	let total_results: Int
	let results: [Movie]
}

extension MovieResults: JSONDecodable {
	init?(dictionary json: JSONDictionary) {
		guard
			let page = json[MovieResultsKeys.page] as? Int,
			let total_pages = json[MovieResultsKeys.totalPages] as? Int,
			let total_results = json[MovieResultsKeys.totalResults] as? Int,
			let results = json[MovieResultsKeys.results] as? [JSONDictionary]
			else { return nil }
		
		self.init(page: page,
				  total_pages: total_pages,
				  total_results: total_results,
				  results: results.compactMap {  Movie.init(dictionary: $0) })
	}
}
