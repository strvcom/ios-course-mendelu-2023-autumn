//
//  APIManager.swift
//  SignMeApp
//
//  Created by Martin Vidovic on 19.09.2023.
//

import Foundation

protocol APIManaging {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

final class APIManager {
    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 30

        return URLSession(configuration: config)
    }()

    private lazy var decoder: JSONDecoder = {
        JSONDecoder()
    }()

    private func request(_ endpoint: Endpoint) async throws -> Data {
        let request: URLRequest = try endpoint.asRequest()

        Logger.log("🚀 Request for \"\(request.description)\"")

        let (data, response) = try await urlSession.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.noResponse
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            throw APIError.unacceptableResponseStatusCode
        }

        // Uncomment this for pretty response logging!
        if let body = String(data: data, encoding: .utf8) {
            Logger.log("""
            ☀️ Response for \"\(request.description)\":
            👀 Status: \(httpResponse.statusCode)
            🧍‍♂️ Body:
            \(body)
            """)
        }

        return data
    }
}

extension APIManager: APIManaging {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let data = try await request(endpoint)
        let object = try decoder.decode(T.self, from: data)

        return object
    }
}
