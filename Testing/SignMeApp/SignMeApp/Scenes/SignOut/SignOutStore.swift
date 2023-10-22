//
//  SignOutStore.swift
//  SignMeApp
//
//  Created by Martin Vidovic on 20.09.2023.
//

import Foundation

final class SignOutStore: ObservableObject {
    private let validationManager: ValidationManaging
    private let apiManager: APIManaging
    
    @Published var user: User?

    init(
        validationManager: ValidationManaging,
        apiManager: APIManaging
    ) {
        self.validationManager = validationManager
        self.apiManager = apiManager
    }
    
    func fetch() async {
        await loadUser()
    }
    
    @MainActor private func loadUser() async {
        
        do {
            let randomNumber = try validationManager.randomNumberInRange(
                from: 1,
                to: 20
            )
            let endpoint = UserRouter.getUser(id: randomNumber)
            user = try await apiManager.request(endpoint)
        } catch {
            print("❌❌❌ \(error)")
        }
    }

}

