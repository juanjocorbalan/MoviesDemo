import Foundation

class DependencyContainer {

	func resolve(year: String) -> MovieListViewController {
		let viewController = MovieListViewController.initFromStoryboard()
		viewController.viewModel = resolve(year: year)
		return viewController
	}
	
	func resolve(movieId: String) -> MovieDetailViewController {
		let viewController = MovieDetailViewController.initFromStoryboard()
		viewController.viewModel = resolve(movieId: movieId)
		return viewController
	}
	
	func resolve() -> FilterListViewController {
		let viewController = FilterListViewController.initFromStoryboard()
		viewController.viewModel = resolve()
		return viewController
	}
	
	func resolve(year: String) -> MovieListViewModel {
		return MovieListViewModel(initialYear: year, getMovieListUseCase: resolve())
	}
	
	func resolve(movieId: String) -> MovieDetailViewModel {
		return MovieDetailViewModel(movieId: movieId, getMovieDetailUseCase: resolve())
	}
	
	func resolve() -> FilterListViewModel {
		return FilterListViewModel(getFilterListUseCase: resolve())
	}
	
	func resolve() -> GetMoviesUseCase {
		return GetMoviesUseCase(movieRepository: resolve())
	}
	
	func resolve() -> GetMovieDetailUseCase {
		return GetMovieDetailUseCase(movieRepository: resolve())
	}
	
	func resolve() -> GetFiltersUseCase {
		return GetFiltersUseCase(movieRepository: resolve())
	}
	
	func resolve() -> MovieRepositoryType {
		return MovieRepository(apiDataSource: resolve(), cacheDataSource: resolve())
	}
	
	func resolve() -> MoviesApiDataSourceType {
		return MoviesApiDataSource(apiClient: resolve())
	}
	
	func resolve() -> MoviesCacheDataSourceType {
        return MoviesCacheDataSource<RealmClient<Movie>>(cacheClient: resolve())
	}
	
	func resolve() -> APIClient {
		return APIClient()
	}
	
	func resolve() -> RealmClient<Movie> {
		return RealmClient<Movie>()
	}
}
