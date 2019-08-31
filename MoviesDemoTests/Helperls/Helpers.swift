import Foundation

@testable import MoviesDemo

func decodeJSONFile<T: Codable>(named fileName: String) -> T? {
	let path = Bundle.main.path(forResource: fileName, ofType: "json")!
    guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return nil }
    return try? JSONDecoder().decode(T.self, from: data)
}
