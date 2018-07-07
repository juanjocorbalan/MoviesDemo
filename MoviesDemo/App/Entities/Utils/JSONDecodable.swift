import Foundation
import RxSwift

typealias JSONDictionary = [String : Any]

protocol JSONDecodable {
	init?(dictionary: JSONDictionary)
}

func decode<T: JSONDecodable>(_ dictionary: JSONDictionary) -> T? {
	return T(dictionary: dictionary)
}

func decode<T: JSONDecodable>(_ dictionaries: [JSONDictionary]) -> [T]? {
	return dictionaries.compactMap(decode)
}

func decode<T: JSONDecodable>(_ data: Data) -> Observable<T> {
	guard
		let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
		let jsonDictionary = jsonObject as? JSONDictionary,
		let object: T = decode(jsonDictionary) else {
			return Observable.error(APIError.serialization)
	}
	return Observable.just(object)
}

func decode<T: JSONDecodable>(_ data: Data) -> Observable<[T]> {
	guard
		let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
		let jsonDictionary = jsonObject as? [JSONDictionary],
		let object: [T] = decode(jsonDictionary) else {
			return Observable.error(APIError.serialization)
	}
	return Observable.just(object)
}
