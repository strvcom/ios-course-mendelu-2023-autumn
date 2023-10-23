//
//  APIManager.swift
//  SignMeApp
//
//  Created by Martin Vidovic on 19.09.2023.
//

import Foundation
import Combine

protocol APIManaging {
    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, Error>
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
}

extension APIManager: APIManaging {
    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, Error> {
        let request: URLRequest
        do {
            request = try endpoint.asRequest()
        } catch {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap({ data, response in
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
            })
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
