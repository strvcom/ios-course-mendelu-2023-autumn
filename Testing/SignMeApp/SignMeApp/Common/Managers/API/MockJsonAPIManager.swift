//
//  MockJsonAPIManager.swift
//  SignMeApp
//
//  Created by Martin Vidovic on 03.10.2023.
//

import Foundation

final class MockJsonAPIManager {
    private lazy var decoder: JSONDecoder = {
        JSONDecoder()
    }()
    
    private func request(_ endpoint: Endpoint) async throws -> Data {
        guard let userRouter = endpoint as? UserRouter else {
            // when Endpoint is not from UserRouter, just return empty Data()
            // func is not failing but test comparison will fail
            return Data()
        }
        switch userRouter {
        case .getUser:
            // return mocked JSON from User
            // code it to Data type
            // when it can't be coded to data, it will just return empty Data() and comparison in test will fail
            return User.mockJSONString.data(using: .utf8) ?? Data()
        }
    }
}

extension MockJsonAPIManager: APIManaging {
    func request<T>(_ endpoint: Endpoint) async throws -> T where T : Decodable {
        // same func as in APIManager
        let data = try await request(endpoint)
        let object = try decoder.decode(T.self, from: data)

        return object
    }
}
