//
//  DIContainer.swift
//  SignMeApp
//
//  Created by Martin Vidovic on 19.09.2023.
//

import Foundation

final class DIContainer {
    // Managers
    let validationManager: ValidationManaging
    let apiManager: APIManaging

    // Stores
    let signInStore: SignInStore
    let signOutStore: SignOutStore
    
    // Mocked
    let mockJsonAPIManager: APIManaging
    let mockJsonSignOutStore: SignOutStore

    init() {
        self.validationManager = ValidationManager()
        self.apiManager = APIManager()
        
        self.signInStore = SignInStore(validationManager: validationManager)
        self.signOutStore = SignOutStore(
            validationManager: validationManager,
            apiManager: apiManager
        )
        
        // Mocked properties - used for testing
        self.mockJsonAPIManager = MockJsonAPIManager()
        self.mockJsonSignOutStore = SignOutStore(
            validationManager: validationManager,
            apiManager: mockJsonAPIManager // we use mocked API manager - creating store with mocked data
        )
    }
}

