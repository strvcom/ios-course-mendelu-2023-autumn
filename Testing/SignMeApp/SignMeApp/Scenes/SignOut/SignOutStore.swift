//
//  SignOutStore.swift
//  SignMeApp
//
//  Created by Martin Vidovic on 20.09.2023.
//

import Foundation
import Combine

final class SignOutStore: ObservableObject {
    private let validationManager: ValidationManaging
    private let apiManager: APIManaging
    
    @Published var user: User?
    private var cancellables: Set<AnyCancellable> = .init()

    init(
        validationManager: ValidationManaging,
        apiManager: APIManaging
    ) {
        self.validationManager = validationManager
        self.apiManager = apiManager

        bind()
    }

    func bind() {
        userPublisher()
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    print("❌❌❌ \(error)")
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &cancellables)
    }

    func userPublisher() -> AnyPublisher<User, Error> {
        Just<Void>(())
            .tryMap { [validationManager] _ -> Int in
                let randomNumber = try validationManager.randomNumberInRange(
                    from: 1,
                    to: 20
                )
                return randomNumber
            }
            .flatMap { [apiManager] randomNumber -> AnyPublisher<User, Error> in
                apiManager.request(UserRouter.getUser(id: randomNumber))
            }
            .eraseToAnyPublisher()
    }
}
