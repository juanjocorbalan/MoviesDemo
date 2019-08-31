import Foundation
import RxSwift

struct APIClientConstants {
	static let retries = 3
	static let timeout: TimeInterval = 10
}

enum APIError: Error {
    case error(String)
    case serialization
    case unauthorized
    case serverError
    case timeout
}

enum HTTPMethod: String {
    case get = "GET"
	case post = "POST"
	case put = "PUT"
	case delete = "DELETE"
}

protocol ResourceType {
    associatedtype ResponseType: Codable
	var url: URL { get set }
	var parameters: [String: String]? { get set }
    var method: HTTPMethod { get }
	
	init(url: URL, parameters: [String: String]?, method: HTTPMethod)
}

struct Resource<T: Codable>: ResourceType {
    typealias ResponseType = T
    public var url: URL
	public var parameters: [String: String]?
    public var method: HTTPMethod
	
    public init(url: URL, parameters: [String: String]? = nil, method: HTTPMethod) {
		self.url = url
		self.parameters = parameters
        self.method = method
	}
}

class APIClient {
	
	private let configuration: URLSessionConfiguration
	
	init(configuration: URLSessionConfiguration = .default) {
		self.configuration = configuration
		self.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
		self.configuration.urlCache = nil
	}
	
    func execute<R: ResourceType>(_ resource: R) -> Observable<R.ResponseType> {
        return request(resource)
            .flatMap { data -> Observable<R.ResponseType> in
                if let data = data {
                    do {
                        let value = try JSONDecoder().decode(R.ResponseType.self, from: data)
                        return Observable.of(value)
                    } catch {
                        return Observable<R.ResponseType>.error(APIError.serialization)
                    }
                } else {
                    return Observable<R.ResponseType>.error(APIError.serialization)
                }
        }
    }
    
    // MARK: - Request
	
	private func request<R: ResourceType>(_ resource: R) -> Observable<Data?> {
		
		var url = resource.url
		if let parametersJSON = resource.parameters {
			var components = URLComponents(string: resource.url.absoluteString)
			components?.queryItems = parametersJSON.map { URLQueryItem(name: $0.0, value: $0.1) }
			if let componentsUrl = components?.url {
				url = componentsUrl
			}
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = resource.method.rawValue
		
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
				return Observable<Data?>.error(APIError.error(error.localizedDescription))
			}
			.timeout(APIClientConstants.timeout, other: Observable<Data?>.error(APIError.timeout), scheduler: MainScheduler.instance)
	}
}
