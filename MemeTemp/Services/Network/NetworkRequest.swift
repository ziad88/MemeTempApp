// Created by Ziad Al-Fakharany

import Foundation

enum HTTPMethods: String {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
}

protocol NetworkRequest {
    var baseURL: String { get }
    var path: MemeEndpoints { get }
    var method: HTTPMethods { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: [String: Any]? { get }
}

extension NetworkRequest {
    var method: HTTPMethods { .GET }
    var headers: [String: String]? { nil }
    var queryItems: [URLQueryItem]? { nil }
    var body: [String: Any]? { nil }

    func asURLRequest() throws -> URLRequest {
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw APIError(error: .urlError, message: "Invalid base URL: \(baseURL)")
        }

        urlComponents.path = path.rawValue

        if let queryItems {
            urlComponents.queryItems = queryItems
        }

        guard let url = urlComponents.url else {
            throw APIError(error: .urlError, message: "Failed to construct URL")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        headers?.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        if let body {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
        }

        return urlRequest
    }
}
