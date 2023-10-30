//
//  SignInViewTests.swift
//  SignMeAppUITests
//
//  Created by Martin Vidovic on 20.09.2023.
//

import XCTest

class SignInViewTests: XCTestCase {
    var app: XCUIApplication!
    
    // we can exclude textField and secureField to computed properties as this button
    // so we don't have to create them in every function
    var button: XCUIElement {
        app.buttons["signInButton"]
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        takeScreenshotOfFailedTest()
        app = nil
    }

    func takeScreenshotOfFailedTest() {
        // this function is written twice -> perfect example for parentClass
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(image: screenshot.image)
        attachment.lifetime = .deleteOnSuccess
        add(attachment)
    }
    
    func testExample() throws {
        XCTAssert(button.exists)
    }
    
    func testInitButtonDisabled() throws {
        XCTAssertEqual(button.isEnabled, false)
    }
    
    func testInit() {
        let textField = app.textFields["signInTextField"]
        let secureField = app.secureTextFields["signInSecureField"]
        XCTAssert(textField.exists)
        XCTAssert(secureField.exists)
        XCTAssert(button.exists)
    }

    func testEmail() {
        let textField = app.textFields["signInTextField"]
        let myEmail = "xxx.yyy@gmail.com"
        textField.tap()
        textField.typeText(myEmail)
        let typedText = textField.value as? String ?? ""
        XCTAssertEqual(typedText, myEmail)
        XCTAssertEqual(button.isEnabled, true)
    }
    
    func testWrongEmail() {
        let textField = app.textFields["signInTextField"]
        let button = app.buttons["signInButton"]
        let myEmail = "xxxRANDOM"
        textField.tap()
        textField.typeText(myEmail)
        let typedText = textField.value as? String ?? ""
        XCTAssertEqual(typedText, myEmail)
        XCTAssertEqual(button.isEnabled, true)
    }
}
