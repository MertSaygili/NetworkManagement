//
//  NetworkManager.swift
//  AlomafireNetwork
//
//  Created by Mert Saygılı on 21.10.2024.
//

import Alamofire
import Foundation

/// Endpoint Protocol
/// - Parameters:
///  - baseURL: Striing
///  - path: String
///  - method: HTTPMethod
///  - parameters: Parameters?
///  - encoding: ParameterEncoding
///  - headers: HTTPHeaders?
protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
    var headers: HTTPHeaders? { get }
}

/// Endpoint Extension
///  - Parameters: URL
///  - Returns: URL
extension Endpoint {
    var url: URL {
        return URL(string: baseURL + path)!
    }
}

final class NetworkManager {
    static let shared: NetworkManager = NetworkManager()
    private let session: Session

    private init() {
        self.session = Session(interceptor: CustomRequestInterceptor())
    }

    /// sending request to server
    /// - Parameter endpoint: Endpoint
    /// - Returns: T
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        return try await withCheckedThrowingContinuation {
            (continuation: CheckedContinuation<T, Error>) in
            request(endpoint) { (result: Result<T, Error>) in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    /// Send a request to the server
    /// - Parameters:
    ///  - endpoint: Endpoint
    ///  - completion: Result<T, Error>
    ///  - T: Decodable
    private func request<T: Decodable>(
        _ endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void
    ) {
        session.request(
            endpoint.url,
            method: endpoint.method,
            parameters: endpoint.parameters,
            encoding: endpoint.encoding,
            headers: endpoint.headers
        )
        .validate()
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

/// Custom Request Interceptor
/// - Parameters:
///    - urlRequest: URLRequest
///    - session: Session
///    - completion: Result<URLRequest, Error>
/// - For:
///     - Adapt URL Request, for session
///     - Add Authorization Bearer Token
///     - Add Accept Language
final class CustomRequestInterceptor: RequestInterceptor {
    func adapt(
        urlRequest: URLRequest, for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var urlRequest = urlRequest

        let token: String =
            DefaultsManager.getValue(key: UserDefaultKeys.token) ?? ""

        let lang: String =
            DefaultsManager.getValue(key: UserDefaultKeys.language) ?? "en"

        urlRequest.headers.add(.authorization(bearerToken: token))
        urlRequest.headers.add(.acceptLanguage(lang))

        completion(.success(urlRequest))
    }
}
