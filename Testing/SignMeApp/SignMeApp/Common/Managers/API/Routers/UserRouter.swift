//
//  UserRouter.swift
//  SignMeAPP
//
//  Created by Martin Vidovic on 17.09.2023.
//

import Foundation

enum UserRouter {
    case getUser(id: Int)
}

extension UserRouter: Endpoint {
    var path: String {
        switch self {
        case let .getUser(id: id):
            return "todos/\(id)"
        }
    }
    
    var urlParameters: [String : Any]? {
        nil
    }
}
