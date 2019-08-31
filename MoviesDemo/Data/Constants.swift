import Foundation

struct MoviesAPI {
	static let key = "b7d89137a1e3cbe1e56141c24731758c"
	static let baseURL = URL(string: "https://api.themoviedb.org/3")!
	static let baseImagesURL = "http://image.tmdb.org/t/p/w185"

	struct paths {
		static let movie = "movie"
		static let discover = "discover"
	}

	struct query {
		// Param names
		static let year = "year"
		static let key = "api_key"
		static let sort = "sort_by"
		// Param values
		static let popularity = "popularity.desc"
	}
}

struct MoviesCache {
	struct keys {
		static let identifier = "identifier"
	}
}

struct MovieKeys {
	static let year = "year"
}
