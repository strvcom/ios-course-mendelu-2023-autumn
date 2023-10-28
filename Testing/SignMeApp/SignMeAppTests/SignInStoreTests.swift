//
//  SignInStoreTests.swift
//  SignMeAppTests
//
//  Created by Martin Vidovic on 27.09.2023.
//

import XCTest
@testable import SignMeApp

class SignInStoreTests: XCTestCase {
    var container: DIContainer!
    var signInStore: SignInStore!

    override func setUpWithError() throws {
        container = DIContainer(apiManager: MockJsonAPIManager())
        signInStore = container.signInStore
    }

    override func tearDownWithError() throws {
        container = nil
        signInStore = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testInit() {
        XCTAssertEqual(signInStore.emailText, "")
        XCTAssertEqual(signInStore.passwordText, "")
        XCTAssertEqual(signInStore.buttonDisabled, true)
    }
    
    func testEmail() {
        let myEmail = "xx"
        signInStore.emailText = myEmail
        XCTAssertEqual(signInStore.emailText, myEmail)
        XCTAssertEqual(signInStore.buttonDisabled, true)
    }
}
