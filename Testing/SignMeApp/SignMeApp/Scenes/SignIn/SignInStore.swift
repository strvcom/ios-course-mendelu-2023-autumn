//
//  SignInStore.swift
//  SignMeApp
//
//  Created by Martin Vidovic on 20.09.2023.
//

import Foundation
import Combine

final class SignInStore: ObservableObject {
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    @Published var buttonDisabled: Bool = true

    private var cancellables: Set<AnyCancellable> = .init()
    private let validationManager: ValidationManaging

    init(validationManager: ValidationManaging) {
        self.validationManager = validationManager
        bind()
    }
}

// MARK: Action
private extension SignInStore {
    func bind() {
        $emailText
            .map { email in
                let correctEmail = self.validationManager.validateEmail(input: email)
                return !correctEmail
            }
            .assign(to: \.buttonDisabled, on: self)
            .store(in: &cancellables)
    }
}
