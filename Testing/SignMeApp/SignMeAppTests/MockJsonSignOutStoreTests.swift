//
//  MockJsonSignOutStoreTests.swift
//  SignMeAppTests
//
//  Created by Martin Vidovic on 03.10.2023.
//

import Foundation
@testable import SignMeApp
import XCTest

final class MockJsonSignOutStoreTests: XCTestCase {
    var container: DIContainer!
    var signOutStore: SignOutStore!
    
    override func setUpWithError() throws {
        container = DIContainer()
        signOutStore = container.mockJsonSignOutStore
    }

    override func tearDownWithError() throws {
        container = nil
        signOutStore = nil
    }
    
    func testInit() {
        // user at start should be nil
        XCTAssertNil(signOutStore.user)
    }
    
    func testUser() async {
        // fetch mocked data
        await signOutStore.fetch()
        // compare mocked data received from MockJsonAPIManager with User.mock
        // should be the same
        // we test here decoding Data to User
        // we test here also logic of SignOutStore
        XCTAssertEqual(signOutStore.user, User.mock)
    }
}

