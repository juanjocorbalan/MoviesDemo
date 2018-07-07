import Foundation

struct SceneAssembler {

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
		return GetMoviesUseCase(movieService: resolve())
	}
	
	func resolve() -> GetMovieDetailUseCase {
		return GetMovieDetailUseCase(movieService: resolve())
	}
	
	func resolve() -> GetFiltersUseCase {
		return GetFiltersUseCase(movieService: resolve())
	}
	
	func resolve() -> MovieService {
		return MovieService(apiRepository: resolve(), cacheRepository: resolve())
	}
	
	func resolve() -> MoviesApiRepository<APIClient<Movie>, APIClient<MovieResults>> {
		return MoviesApiRepository(movieApiClient: resolve(), movieResultsApiClient: resolve())
	}
	
	func resolve() -> MoviesCacheRepository<RealmClient<Movie>> {
		return MoviesCacheRepository(cacheClient: resolve())
	}
	
	func resolve() -> APIClient<Movie> {
		return APIClient<Movie>()
	}
	
	func resolve() -> APIClient<MovieResults> {
		return APIClient<MovieResults>()
	}
	
	func resolve() -> RealmClient<Movie> {
		return RealmClient<Movie>()
	}

	func resolve() -> CoreDataClient<Movie> {
		return CoreDataClient<Movie>()
	}
}
