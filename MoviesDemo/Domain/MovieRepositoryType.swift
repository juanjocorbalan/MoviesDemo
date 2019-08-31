import Foundation
import RxSwift

protocol MovieRepositoryType {
    func getTopMovies(by year: String) -> Observable<[Movie]>
    func getMovieDetail(by id: String) -> Observable<Movie>
    func getFilters() -> Observable<[String]>
}
