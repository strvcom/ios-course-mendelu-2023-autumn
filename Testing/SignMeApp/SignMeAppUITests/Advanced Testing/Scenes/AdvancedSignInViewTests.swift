//
//  AdvancedSignInViewTests.swift
//  SignMeAppUITests
//
//  Created by Martin Vidovic on 03.10.2023.
//

import Foundation
import XCTest

final class AdvancedSignInViewTests: XCTestCase {
    /*
     in this file, we can see the same testing as it is in SignInViewTests
     but it's more advanced - we don't have to create public properties for UI elements
     also we don't have to store emails here - we have SignInScene for it
     this way we can achieve clean and short file for UI testing
     and everything else is written in different files - we improved readability
     */
    var app: XCUIApplication!
    var scene: SignInScene!

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
        scene = app.signInScene
    }

    override func tearDownWithError() throws {
        takeScreenshotOfFailedTest()
        app = nil
    }

    func takeScreenshotOfFailedTest() {
        // this function is written more than once -> figure something out, how to write it only once
        // suggestion: protocol with func written in extension, or just extension to XCUIApplication
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(image: screenshot.image)
        attachment.lifetime = .deleteOnSuccess
        add(attachment)
    }
    
    func testSignIn() throws {
        // UI tests must launch the application that they test.
        XCTAssert(scene.signInButton.exists)
        XCTAssert(scene.emailTextField.exists)
        XCTAssertTrue(scene.passwordTextField.exists)
    }

    func testEmailTyping() {
        let myEmail = SignInScene.EmailStrings.email.rawValue
        scene.emailTextField.tap()
        scene.emailTextField.typeText(myEmail)
        let text = scene.emailTextField.value as? String ?? ""
        XCTAssertEqual(text, myEmail)
        XCTAssertTrue(text == myEmail)
    }
    
    func testButtonEnabled() {
        let myEmail = SignInScene.EmailStrings.email.rawValue
        scene.emailTextField.tap()
        scene.emailTextField.typeText(myEmail)
        let text = scene.emailTextField.value as? String ?? ""
        XCTAssertEqual(text, myEmail) // " + aaaa") + show screenshot
        XCTAssertEqual(scene.signInButton.isEnabled, true)
    }
    
    func testButtonDisabled() {
        let myEmail = SignInScene.EmailStrings.wrongEmail.rawValue
        scene.emailTextField.tap()
        scene.emailTextField.typeText(myEmail)
        let text = scene.emailTextField.value as? String ?? ""
        XCTAssertEqual(text, myEmail) // " + aaaa") + show screenshot
        XCTAssertEqual(scene.signInButton.isEnabled, false)
    }

    func testSignInButtonDisability() {
        XCTAssertEqual(scene.signInButton.isEnabled, false)
    }
    
    func testRecord() {
        // click inside of this func and press record
        // red dot at the bottom of the screen
    }
}
