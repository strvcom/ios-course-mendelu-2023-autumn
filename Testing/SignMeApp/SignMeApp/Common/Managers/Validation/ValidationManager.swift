//
//  ValidationManager.swift
//  SignMeApp
//
//  Created by Martin Vidovic on 20.09.2022.
//

import Foundation

protocol ValidationManaging {
    func validateEmail(input: String) -> Bool
    func randomNumberInRange(from: Int, to: Int) throws -> Int
}

final class ValidationManager: ValidationManaging {
    func randomNumberInRange(from: Int, to: Int) throws -> Int {
        return Int.random(in: from..<to)
    }
    
    func validateEmail(input: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: input)
    }
}

