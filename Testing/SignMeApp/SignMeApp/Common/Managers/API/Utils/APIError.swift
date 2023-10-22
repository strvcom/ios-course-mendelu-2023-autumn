//
//  APIError.swift
//  SignMeAPP
//
//  Created by Martin Vidovic on 17.09.2023.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidUrlComponents
    case noResponse
    case unacceptableResponseStatusCode
    case customDecodingFailed
    case malformedUrl
}
