//
//  SignOutStoreTests.swift
//  SignMeAppTests
//
//  Created by Martin Vidovic on 03.10.2023.
//

import Foundation
@testable import SignMeApp
import XCTest

final class SignOutStoreTests: XCTestCase {
    var container: DIContainer!
    var signOutStore: SignOutStore!
    
    override func setUpWithError() throws {
        container = DIContainer()
        signOutStore = container.signOutStore
    }

    override func tearDownWithError() throws {
        container = nil
        signOutStore = nil
    }
    
    func testInit() {
        XCTAssertNil(signOutStore.user)
    }
    
    func testUser() async {
        await signOutStore.fetch()
        XCTAssertNotNil(signOutStore.user)
    }
}

