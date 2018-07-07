import Foundation

@testable import MoviesDemo

func getJSONDictionaryFromFile(named fileName: String, inBundle bundle: Bundle) -> JSONDictionary {
	let path = bundle.path(forResource: fileName, ofType: "json")!
	let data = try? Data(contentsOf: URL(fileURLWithPath: path))
	return try! JSONSerialization.jsonObject(with: data!, options: []) as! JSONDictionary
}
