import Foundation
import RxSwift

protocol MoviesApiDataSourceType {
    func getMovie(by id: String) -> Observable<Movie>
    func getMovies(by year: String) -> Observable<[Movie]>
}

class MoviesApiDataSource: MoviesApiDataSourceType {
    
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getMovie(by id: String) -> Observable<Movie> {
        
        var url = MoviesAPI.baseURL.appendingPathComponent(MoviesAPI.paths.movie)
        url.appendPathComponent(id)
        
        let parameters = [MoviesAPI.query.key: MoviesAPI.key]
        
        let resource = Resource<MovieDto>(url: url, parameters: parameters, method: HTTPMethod.get)
        
        return apiClient.execute(resource).map { $0.toDomain() }
    }
    
    func getMovies(by year: String) -> Observable<[Movie]> {
        
        var url = MoviesAPI.baseURL.appendingPathComponent(MoviesAPI.paths.discover)
        url.appendPathComponent(MoviesAPI.paths.movie)
        
        let parameters = [MoviesAPI.query.key: MoviesAPI.key,
                          MoviesAPI.query.sort: MoviesAPI.query.popularity,
                          MoviesAPI.query.year: year]
        
        let resource = Resource<MovieResultsDto>(url: url, parameters: parameters, method: HTTPMethod.get)
        
        return apiClient.execute(resource)
            .map { $0.results
                .toDomain().map {
                    var movie = $0
                    movie.year = year
                    return movie
                }
        }
    }
}
