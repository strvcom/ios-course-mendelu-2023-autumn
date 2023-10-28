//
//  ValidationManagerTests.swift
//  SignMeAppTests
//
//  Created by Martin Vidovic on 20.09.2023.
//

import Foundation
import XCTest
@testable import SignMeApp

final class ValidationManagerTests: XCTestCase {
    var container: DIContainer!
    var validationManager: ValidationManaging!
    
    override func setUpWithError() throws {
        container = DIContainer(apiManager: MockJsonAPIManager())
        validationManager = container.validationManager
    }
    
    override func tearDownWithError() throws {
        container = nil
        validationManager = nil
    }
    
    func testCorrectEmail() {
        let email = "abcd@efgh.ijkl"
        let result = validationManager.validateEmail(input: email)
        XCTAssertEqual(result, true)
    }
    
    func testWrongEmail() {
        let email = "Martin"
        let result = validationManager.validateEmail(input: email)
        XCTAssertEqual(result, false)
    }

    func testCrazyEmail() {
        let email = ".@gmail.com"
        let result = validationManager.validateEmail(input: email)
        XCTAssertEqual(result, true)
    }
    
    func testRange() throws {
        let minimum = 1
        let maximum = 20
        let number = try validationManager.randomNumberInRange(from: minimum, to: maximum)
        let range = minimum...maximum
        XCTAssertEqual(range.contains(number), true)
    }
    
    func testRangeError() throws {
        let minimum = 20
        let maximum = 1
        do {
            let number = try validationManager.randomNumberInRange(from: minimum, to: maximum)
            let range = minimum...maximum
            XCTAssertEqual(range.contains(number), true)
        } catch {
            if let validationError = error as? ValidationError {
                XCTAssertEqual(validationError, ValidationError.wrongRange)
            } else {
                XCTFail()
            }
        }
    }
}
