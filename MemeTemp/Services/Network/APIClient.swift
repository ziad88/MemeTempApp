// Created by Ziad Al-Fakharany

import Foundation
import Network

actor APIClient {
    static let shared = APIClient()

    private let session: URLSession
    private let monitor = NWPathMonitor()
    private var isConnected = true

    private static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()

    private init() {
        let config = URLSessionConfiguration.default
        config.urlCache = URLCache(
            memoryCapacity: 20_000_000,
            diskCapacity: 100_000_000
        )
        config.timeoutIntervalForRequest = 30
        session = URLSession(configuration: config)

        let monitorQueue = DispatchQueue(label: "com.memetempapp.network.monitor")
        monitor.pathUpdateHandler = { [weak self] path in
            Task { [weak self] in
                await self?.updateConnectivity(path.status == .satisfied)
            }
        }
        monitor.start(queue: monitorQueue)
    }

    private func updateConnectivity(_ connected: Bool) {
        isConnected = connected
    }

    func request<T: Codable>(request: any NetworkRequest, model: T.Type) async throws -> T {
        guard isConnected else {
            throw APIError(error: .noInternetConnection, message: "No internet connection")
        }

        let urlRequest: URLRequest
        do {
            urlRequest = try request.asURLRequest()
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError(error: .urlError, message: error.localizedDescription)
        }

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch {
            throw APIError(error: .noInternetConnection, message: error.localizedDescription)
        }

        return try handleResponse(data: data, response: response, model: model)
    }

    private func handleResponse<T: Codable>(data: Data, response: URLResponse, model: T.Type) throws -> T {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError(error: .unknownApiError)
        }

        switch httpResponse.statusCode {
        case 200...299:
            guard !data.isEmpty else {
                throw APIError(error: .noData, statusCode: httpResponse.statusCode)
            }
            do {
                return try Self.jsonDecoder.decode(model.self, from: data)
            } catch {
                throw APIError(error: .encodeError(rawError: error), statusCode: httpResponse.statusCode)
            }
        case 400:
            throw APIError(error: .badRequest, statusCode: httpResponse.statusCode)
        default:
            throw APIError(error: .unknownApiError, statusCode: httpResponse.statusCode)
        }
    }
}
