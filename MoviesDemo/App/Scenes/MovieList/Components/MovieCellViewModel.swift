import Foundation

struct MovieCellViewModel {
	let identifier: String
	let title: String
	let releaseDate: String
	let voteAverage: String
	let overview: String
	let poster: URL?
	
	init(movie: Movie) {
		self.identifier = movie.identifier
		self.title = movie.originalTitle
		self.releaseDate = movie.releaseDate
		self.voteAverage = "\(movie.voteAverage)"
		self.overview = movie.overview
		self.poster = URL(string: movie.posterPath)
	}
}
