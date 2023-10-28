//
//  MockJsonSignOutStoreTests.swift
//  SignMeAppTests
//
//  Created by Martin Vidovic on 03.10.2023.
//

import Foundation
@testable import SignMeApp
import XCTest
import Combine

final class MockJsonSignOutStoreTests: XCTestCase {
    var container: DIContainer!
    var signOutStore: SignOutStore!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        // we replaced here APIManager with MockJsonAPIManager
        // this means that we are mocking API connection
        // no request is sent to Backend, we just return our own response
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
        // user at start should be nil
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
        // compare mocked data received from MockJsonAPIManager with User.mock
        // should be the same
        // we test here decoding Data to User
        // we test here also logic of SignOutStore
        XCTAssertEqual(result, User.mock)
    }
}
