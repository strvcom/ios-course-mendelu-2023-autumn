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
