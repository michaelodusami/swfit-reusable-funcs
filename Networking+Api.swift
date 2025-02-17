//
//  APIError.swift
//  YourProject
//
//  Created by YourName on Date.
//

import Foundation

public enum APIError: Error, CustomStringConvertible {
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case unauthorized
    case notFound
    case serverError(Int)
    case unknown

    public var description: String {
        switch self {
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from the server."
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .unauthorized:
            return "Unauthorized access."
        case .notFound:
            return "Resource not found."
        case .serverError(let code):
            return "Server error with status code: \(code)"
        case .unknown:
            return "An unknown error occurred."
        }
    }
}


//
//  Endpoint.swift
//  YourProject
//
//  Created by YourName on Date.
//

import Foundation

public enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

public protocol EndpointProtocol {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
    var headers: [String: String]? { get }
}

public enum Endpoint: EndpointProtocol {
    case getUser(id: Int)
    case createUser
    case updateUser(id: Int)
    case deleteUser(id: Int)
    case custom(path: String, method: HTTPMethod, queryItems: [URLQueryItem]?, body: Data?)

    public var baseURL: URL {
        // Set your API base URL here.
        return URL(string: "https://api.example.com")!
    }

    public var path: String {
        switch self {
        case .getUser(let id):
            return "/users/\(id)"
        case .createUser:
            return "/users"
        case .updateUser(let id):
            return "/users/\(id)"
        case .deleteUser(let id):
            return "/users/\(id)"
        case .custom(let path, _, _, _):
            return path
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .getUser:
            return .GET
        case .createUser:
            return .POST
        case .updateUser:
            return .PUT
        case .deleteUser:
            return .DELETE
        case .custom(_, let method, _, _):
            return method
        }
    }

    public var queryItems: [URLQueryItem]? {
        switch self {
        case .custom(_, _, let queryItems, _):
            return queryItems
        default:
            return nil
        }
    }

    public var body: Data? {
        switch self {
        case .createUser, .updateUser, .custom(_, _, _, let body):
            return body
        default:
            return nil
        }
    }

    public var headers: [String: String]? {
        // Provide common headers if necessary.
        return ["Content-Type": "application/json"]
    }

    /// Constructs a URLRequest from the endpoint.
    public var urlRequest: URLRequest? {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems
        guard let url = components?.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        return request
    }
}


//
//  ResponseHandler.swift
//  YourProject
//
//  Created by YourName on Date.
//

import Foundation

public class ResponseHandler {
    /// Processes the URLSession response and returns either Data or an APIError.
    public static func handleResponse(data: Data?, response: URLResponse?, error: Error?) -> Result<Data, APIError> {
        if let error = error {
            return .failure(.networkError(error))
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(.invalidResponse)
        }
        switch httpResponse.statusCode {
        case 200...299:
            if let data = data {
                return .success(data)
            } else {
                return .failure(.invalidResponse)
            }
        case 401:
            return .failure(.unauthorized)
        case 404:
            return .failure(.notFound)
        case 500...599:
            return .failure(.serverError(httpResponse.statusCode))
        default:
            return .failure(.unknown)
        }
    }
}


//
//  NetworkManager.swift
//  YourProject
//
//  Created by YourName on Date.
//

import Foundation

public class NetworkManager {
    public static let shared = NetworkManager()
    private init() { }

    private let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        // Customize configuration if needed.
        return URLSession(configuration: configuration)
    }()

    /// Executes a URLRequest and returns data via a completion handler.
    public func execute(request: URLRequest, completion: @escaping (Result<Data, APIError>) -> Void) {
        session.dataTask(with: request) { data, response, error in
            let result = ResponseHandler.handleResponse(data: data, response: response, error: error)
            DispatchQueue.main.async {
                completion(result)
            }
        }.resume()
    }
}


//
//  APIClient.swift
//  YourProject
//
//  Created by YourName on Date.
//

import Foundation

public class APIClient {
    public static let shared = APIClient()
    private init() { }

    /// Generic function to perform an API request and decode the response.
    public func request<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let request = endpoint.urlRequest else {
            completion(.failure(.invalidResponse))
            return
        }

        NetworkManager.shared.execute(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


//
//  WebSocketManager.swift
//  YourProject
//
//  Created by YourName on Date.
//

import Foundation

public protocol WebSocketManagerDelegate: AnyObject {
    func webSocketDidConnect(_ manager: WebSocketManager)
    func webSocketDidDisconnect(_ manager: WebSocketManager, error: Error?)
    func webSocket(_ manager: WebSocketManager, didReceiveMessage message: String)
}

public class WebSocketManager: NSObject {
    public static let shared = WebSocketManager()
    private override init() { super.init() }

    private var webSocketTask: URLSessionWebSocketTask?
    private var urlSession: URLSession!
    
    public weak var delegate: WebSocketManagerDelegate?
    
    /// Connects to a WebSocket server using the provided URL.
    public func connect(url: URL) {
        let configuration = URLSessionConfiguration.default
        urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue())
        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask?.resume()
        listen()
    }
    
    /// Sends a text message over the WebSocket.
    public func send(message: String, completion: ((Error?) -> Void)? = nil) {
        let wsMessage = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(wsMessage, completionHandler: completion ?? { _ in })
    }
    
    /// Listens for incoming messages.
    private func listen() {
        webSocketTask?.receive { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.webSocketDidDisconnect(self, error: error)
                }
            case .success(let message):
                switch message {
                case .string(let text):
                    DispatchQueue.main.async {
                        self.delegate?.webSocket(self, didReceiveMessage: text)
                    }
                case .data(let data):
                    if let text = String(data: data, encoding: .utf8) {
                        DispatchQueue.main.async {
                            self.delegate?.webSocket(self, didReceiveMessage: text)
                        }
                    }
                @unknown default:
                    break
                }
                // Continue listening.
                self.listen()
            }
        }
    }
    
    /// Disconnects from the WebSocket server.
    public func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
}

// MARK: - URLSessionWebSocketDelegate
extension WebSocketManager: URLSessionWebSocketDelegate {
    public func urlSession(_ session: URLSession,
                           webSocketTask: URLSessionWebSocketTask,
                           didOpenWithProtocol protocol: String?) {
        DispatchQueue.main.async {
            self.delegate?.webSocketDidConnect(self)
        }
    }
    
    public func urlSession(_ session: URLSession,
                           webSocketTask: URLSessionWebSocketTask,
                           didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                           reason: Data?) {
        DispatchQueue.main.async {
            self.delegate?.webSocketDidDisconnect(self, error: nil)
        }
    }
}
