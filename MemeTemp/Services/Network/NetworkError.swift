// Created by Ziad Al-Fakharany

import Foundation

struct APIError: Error {
    static let somethingWentWrongMsg = "Something went wrong"

    enum NetworkError: Error, Equatable {
        static func == (lhs: APIError.NetworkError, rhs: APIError.NetworkError) -> Bool {
            lhs.errorDescription == rhs.errorDescription
        }

        case noData
        case noInternetConnection
        case encodeError(rawError: Error?)
        case badRequest
        case urlError
        case unknownApiError

        var errorDescription: String {
            switch self {
            case .noData:
                return "No Data Returned"
            case .noInternetConnection:
                return "No internet connection"
            case .encodeError:
                return "Invalid response or encoding error"
            case .urlError:
                return "Invalid URL"
            case .unknownApiError:
                return APIError.somethingWentWrongMsg
            case .badRequest:
                return "Bad Request or invalid data"
            }
        }
    }

    let error: NetworkError
    let statusCode: Int
    let message: String

    init(
        error: NetworkError,
        statusCode: Int = 0,
        message: String = APIError.somethingWentWrongMsg
    ) {
        self.error = error
        self.statusCode = statusCode
        self.message = message
    }
}
