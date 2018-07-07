import Foundation
import RxSwift

struct APIClientConstants {
	static let retries = 3
	static let timeout: TimeInterval = 10
}

enum HTTPMethod: String {
	
	case get = "GET"
	case post = "POST"
	case put = "PUT"
	case delete = "DELETE"
}

protocol ResourceType {
	var url: URL { get set }
	var parameters: [String: String]? { get set }
	var body: [String: Any]? { get set }
	var headers: [String: String]? { get set }
	
	init(url: URL, parameters: [String: String]?, body: [String: Any]?, headers: [String: String]?)
}

struct Resource: ResourceType {
	public var url: URL
	public var parameters: [String: String]?
	public var body: [String: Any]?
	public var headers: [String: String]?
	
	public init(url: URL, parameters: [String: String]? = nil, body: [String: Any]? = nil, headers: [String: String]? = nil) {
		self.url = url
		self.parameters = parameters
		self.body = body
		self.headers = headers
	}
}

class APIClient<T: JSONDecodable>: APIClientType {
	
	let configuration: URLSessionConfiguration
	
	init(configuration: URLSessionConfiguration = .default) {
		self.configuration = configuration
		self.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
		self.configuration.urlCache = nil
	}
	
	func getItem(forResource resource: ResourceType) -> Observable<T> {
		return request(forResource: resource, method: .get)
			.flatMap { decode($0) }
	}
	
	func getItems(forResource resource: ResourceType) -> Observable<[T]> {
		return request(forResource: resource, method: .get)
			.flatMap { decode($0) }
	}
	
	func postItem(forResource resource: ResourceType) -> Observable<T> {
		return request(forResource: resource, method: .post)
			.flatMap { decode($0) }
	}
	
	func updateItem(forResource resource: ResourceType) -> Observable<T> {
		return request(forResource: resource, method: .put)
			.flatMap { decode($0) }
	}
	
	func deleteItem(forResource resource: ResourceType) -> Observable<T> {
		return request(forResource: resource, method: .delete)
			.flatMap { decode($0) }
	}
	
	// MARK: - Request
	
	private func request(forResource resource: ResourceType, method: HTTPMethod) -> Observable<Data> {
		
		var url = resource.url
		if let parametersJSON = resource.parameters {
			var components = URLComponents(string: resource.url.absoluteString)
			components?.queryItems = parametersJSON.map { URLQueryItem(name: $0.0, value: $0.1) }
			if let componentsUrl = components?.url {
				url = componentsUrl
			}
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = method.rawValue
		
		if let bodyJSON = resource.body {
			do {
				request.httpBody = try JSONSerialization.data(withJSONObject: bodyJSON, options: [.prettyPrinted])
			} catch {
				return Observable.error(APIError.serialization)
			}
		}
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		
		let session = URLSession(configuration: configuration)
		
		return Observable.create { observer in
			
			let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
				
				if let httpResponse = response as? HTTPURLResponse {
					switch httpResponse.statusCode {
					case 200..<300:
						if error == nil, let data = data {
							observer.onNext(data)
							observer.onCompleted()
						} else {
							observer.onError(APIError.error(error?.localizedDescription ?? ""))
						}
					case 401:
						observer.onError(APIError.unauthorized)
					case 500...599:
						observer.onError(APIError.serverError)
					default:
						observer.onError(APIError.error(error?.localizedDescription ?? ""))
					}
				}
			}
			task.resume()
			return Disposables.create(with: {
				task.cancel()
			})
			}
			.retry(APIClientConstants.retries)
			.catchError { error in
				return Observable<Data>.error(APIError.error(error.localizedDescription))
			}
			.timeout(APIClientConstants.timeout, other: Observable<Data>.error(APIError.timeout), scheduler: MainScheduler.instance)
	}
}
