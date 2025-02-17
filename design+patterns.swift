//
//  MVVMTemplate.swift
//  YourProject
//
//  Created by YourName on Date.
//

import Foundation
import Combine

/// Base ViewModel for MVVM pattern.
public class BaseViewModel: ObservableObject {
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    
    public init() { }
    
    /// Common error handling.
    public func handleError(_ error: Error) {
        self.errorMessage = error.localizedDescription
    }
}
// OR

@Observable class BaseViewModel {
    public var isLoading: Bool = false
    public var errorMessage: String?
    
    public init() { }
    
    /// Common error handling.
    public func handleError(_ error: Error) {
        self.errorMessage = error.localizedDescription
    }
}


//
//  MVPTemplate.swift
//  YourProject
//
//  Created by YourName on Date.
//

import Foundation

/// Protocol defining basic view methods for MVP.
public protocol MVPView: AnyObject {
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
}

/// Base Presenter class for MVP pattern.
public class BasePresenter<View: MVPView> {
    public weak var view: View?
    
    public init(view: View) {
        self.view = view
    }
    
    public func attachView(_ view: View) {
        self.view = view
    }
    
    public func detachView() {
        self.view = nil
    }
    
    /// Handles errors and forwards them to the view.
    public func handleError(_ error: Error) {
        view?.showError(error.localizedDescription)
    }
}


//
//  Coordinator.swift
//  YourProject
//
//  Created by YourName on Date.
//

import UIKit

/// Coordinator protocol for managing navigation flows.
public protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

/// Base Coordinator implementation.
public class BaseCoordinator: Coordinator {
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }
    
    /// Override in subclasses to define navigation start.
    public func start() {
        // Implementation goes here.
    }
}


//
//  DIContainer.swift
//  YourProject
//
//  Created by YourName on Date.
//

import Foundation

/// Simple dependency injection container.
public final class DIContainer {
    public static let shared = DIContainer()
    
    private var factories: [String: () -> Any] = [:]
    
    private init() { }
    
    /// Registers a factory for the given type.
    public func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        let key = "\(type)"
        factories[key] = factory
    }
    
    /// Resolves and returns an instance of the given type.
    public func resolve<T>(_ type: T.Type) -> T? {
        let key = "\(type)"
        return factories[key]?() as? T
    }
}


//
//  ObservableObject.swift
//  YourProject
//
//  Created by YourName on Date.
//

import Foundation
import Combine

/// Global app state manager using SwiftUI's ObservableObject.
public class AppState: ObservableObject {
    public static let shared = AppState()
    
    @Published public var isLoggedIn: Bool = false
    @Published public var currentUser: String? = nil
    @Published public var appTheme: String = "Light"
    
    private init() { }
}


//
//  NetworkServiceProtocol.swift
//  YourProject
//
//  Created by YourName on Date.
//

import Foundation

/// Protocol defining networking interfaces.
public protocol NetworkServiceProtocol {
    /// Performs a network request to the given endpoint and decodes the response.
    func request<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<T, APIError>) -> Void)
}


//
//  StorageServiceProtocol.swift
//  YourProject
//
//  Created by YourName on Date.
//

import Foundation

/// Protocol defining database/storage interfaces.
public protocol StorageServiceProtocol {
    /// Saves an encodable object for a given key.
    func save<T: Encodable>(_ object: T, forKey key: String) throws
    
    /// Retrieves a decodable object of the specified type for a given key.
    func retrieve<T: Decodable>(forKey key: String, as type: T.Type) throws -> T?
    
    /// Removes the stored object for the given key.
    func remove(forKey key: String) throws
}


