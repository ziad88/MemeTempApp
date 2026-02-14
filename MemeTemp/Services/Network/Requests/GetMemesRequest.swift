// Created by Ziad Al-Fakharany

import Foundation

struct GetMemesRequest: NetworkRequest {
    var baseURL: String { "https://api.imgflip.com" }

    var path: MemeEndpoints { .getMemes }

    var headers: [String: String]?
    var queryItems: [URLQueryItem]?
    var body: [String: Any]?
}
