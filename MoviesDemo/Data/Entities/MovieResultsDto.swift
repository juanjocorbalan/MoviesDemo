import Foundation

struct MovieResultsDto: Codable {
    let page: Int
    let total_pages: Int
    let total_results: Int
    let results: [MovieDto]
}


extension MovieResultsDto: DomainConvertibleEntity {
    
    func toDomain() -> MovieResults {
        return MovieResults(page: page,
                            total_pages: total_pages,
                            total_results: total_results,
                            results: results.toDomain())
    }
}
