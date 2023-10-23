//
//  MockJsonAPIManager.swift
//  SignMeApp
//
//  Created by Martin Vidovic on 03.10.2023.
//

import Foundation
import Combine

final class MockJsonAPIManager {
    private lazy var decoder: JSONDecoder = {
        JSONDecoder()
    }()
    
    private func request(_ endpoint: Endpoint) -> AnyPublisher<Data, Never> {
        guard let userRouter = endpoint as? UserRouter else {
            // when Endpoint is not from UserRouter, just return empty Data()
            // func is not failing but test comparison will fail
            let emptyData = Data()
            return Just<Data>(emptyData).eraseToAnyPublisher()
        }
        switch userRouter {
        case .getUser:
            // return mocked JSON from User
            // code it to Data type
            // when it can't be coded to data, it will just return empty Data() and comparison in test will fail
            let data = User.mockJSONString.data(using: .utf8) ?? Data()
            return Just<Data>(data).eraseToAnyPublisher()
        }
    }
}

extension MockJsonAPIManager: APIManaging {
    func request<T>(_ endpoint: Endpoint) -> AnyPublisher<T, Error> where T : Decodable {
        request(endpoint)
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
