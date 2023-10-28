//
//  User.swift
//  SignMeApp
//
//  Created by Martin Vidovic on 20.09.2023.
//

import Foundation

struct User: Decodable, Equatable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}

// MARK: Testing
extension User {
    // Make sure these mock data have the same value
    // We use them for testing
    static let mock: User = .init(userId: 1, id: 1, title: "delectus aut autem", completed: false)
    static let mockJSONString = """
    {
        "userId": 1,
        "id": 1,
        "title": "delectus aut autem",
        "completed": false
    }
    """
}
