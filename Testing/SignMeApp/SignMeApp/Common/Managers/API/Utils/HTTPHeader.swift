//
//  HTTPHeader.swift
//  SignMeAPP
//
//  Created by Martin Vidovic on 17.09.2023.
//

enum HTTPHeader {
    enum HeaderField: String {
        case contentType = "Content-Type"
    }

    enum ContentType: String {
        case json = "application/json"
        case text = "text/html;charset=utf-8"
    }
}
