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

    init(
        validationManager: ValidationManaging = ValidationManager(),
        apiManager: APIManaging = APIManager()
    ) {
        self.validationManager = validationManager
        self.apiManager = apiManager
        
        self.signInStore = SignInStore(validationManager: validationManager)
        self.signOutStore = SignOutStore(
            validationManager: validationManager,
            apiManager: apiManager
        )
    }
}
