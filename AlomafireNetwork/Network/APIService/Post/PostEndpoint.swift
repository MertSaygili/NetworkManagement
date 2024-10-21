//
//  PostEndpoint.swift
//  AlomafireNetwork
//
//  Created by Mert Saygılı on 21.10.2024.
//

import Alamofire

/// Enum for post endpoints
enum PostEndpoint {
    case getPosts
    case getPost(id: Int)
}

/// Conform to Endpoint protocol
/// - Returns: Base URL, HTTP method, parameters, encoding, headers and path
extension PostEndpoint: Endpoint {
    var baseURL: String {
        NetworkConfig.baseURL
    }

    var method: HTTPMethod {
        switch self {
        case .getPosts, .getPost:
            return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case .getPosts:
            return nil
        case .getPost(let id):
            return ["id": id]
        }
    }

    var encoding: any ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }

    var path: String {
        switch self {
        case .getPosts:
            return "/posts"
        case .getPost(let id):
            return "/posts/\(id)"
        }
    }
}
