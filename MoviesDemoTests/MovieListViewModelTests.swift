import XCTest
import RxSwift
@testable import MoviesDemo

class MoviesListViewModelTests: XCTestCase {
	
	private var disposeBag = DisposeBag()

	var sut: MovieListViewModel!
	
    override func setUp() {
        super.setUp()

		let fakeUseCase = GetMoviesUseCaseFake()
		
		sut = MovieListViewModel(initialYear: "2018", getMovieListUseCase: fakeUseCase)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testViewModelProvidesTitleObservable() {

		let expectation = XCTestExpectation(description: "MoviesLisrViewModelTests should provide movies array observable")
		
		sut.title
			.subscribe(onNext: { title in
				XCTAssertEqual(title, "2018 Top Movies")
				expectation.fulfill()
			})
			.disposed(by: disposeBag)
		
		sut.reload.onNext(())
		
		wait(for: [expectation], timeout: 3.0)
    }

	func testViewModelProvidesMoviesArrayObservable() {
		
		let expectation = XCTestExpectation(description: "MoviesLisrViewModelTests should provide movies array observable")

		sut.movies
			.skip(1) // skip first event (cache response): there aren't any cached movies at point
			.subscribe(onNext: { movies in
				XCTAssertEqual(movies.count, 20)
				expectation.fulfill()
			})
			.disposed(by: disposeBag)
		
		sut.reload.onNext(())

		wait(for: [expectation], timeout: 3.0)
	}
}
