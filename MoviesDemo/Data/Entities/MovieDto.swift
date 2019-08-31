import Foundation

struct MovieDto: Codable {
    let id: Int
    let original_title: String
    let overview: String
    let release_date: String
    let vote_average: Double
    var poster_path: String
    var year: String?
}

extension MovieDto: DomainConvertibleEntity {
    
    func toDomain() -> Movie {
        return Movie(identifier: "\(id)",
                     originalTitle: original_title,
                     releaseDate: release_date,
                     voteAverage: vote_average,
                     overview: overview,
                     posterPath: poster_path,
                     year: year ?? "")
    }
}
