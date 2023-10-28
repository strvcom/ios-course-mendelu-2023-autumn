//
//  SignOutStoreTests.swift
//  SignMeAppTests
//
//  Created by Martin Vidovic on 03.10.2023.
//

import Foundation
@testable import SignMeApp
import XCTest
import Combine

final class SignOutStoreTests: XCTestCase {
    var container: DIContainer!
    var signOutStore: SignOutStore!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        container = DIContainer(apiManager: MockJsonAPIManager())
        signOutStore = container.signOutStore
        cancellables = []
    }

    override func tearDownWithError() throws {
        container = nil
        signOutStore = nil
        cancellables = nil
    }
    
    func testInit() {
        XCTAssertNil(signOutStore.user)
    }
    
    func testUser() {
        // set expectation
        let expectation = expectation(description: "UserPublisher")
        // fetch mocked data
        var result: User?
        signOutStore.userPublisher().sink { completion in
            switch completion {
            case .finished:
                break
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }

            // Fullfilling our expectation to unblock
            // our test execution:
            expectation.fulfill()
        } receiveValue: { user in
            result = user
        }
        .store(in: &cancellables)

        waitForExpectations(timeout: 10)
        // we can't compare users because we receive random user from Backend
        // so we can test if we received any result -> user should not be nil
        XCTAssertNotNil(result)
    }
}
