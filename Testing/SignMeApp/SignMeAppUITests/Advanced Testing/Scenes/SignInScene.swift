//
//  SignInScene.swift
//  SignMeAppUITests
//
//  Created by Martin Vidovic on 03.10.2023.
//

import XCTest

struct SignInScene: Scene {
    // UI Elements
    var app: XCUIApplication
    
    var signInButton: XCUIElement {
        app.buttons["signInButton"]
    }

    var emailTextField: XCUIElement {
        app.textFields["signInTextField"]
    }
    
    var passwordTextField: XCUIElement {
        app.secureTextFields["signInSecureField"]
    }

    // Types needed for testing
    enum EmailStrings: String {
        case email = "xxx.yyy@zzzz.com"
        case wrongEmail = "xxxRANDOM"
    }
}
