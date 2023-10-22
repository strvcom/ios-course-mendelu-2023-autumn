//
//  SignCoordinator.swift
//  SignMeApp
//
//  Created by Martin Vidovic on 19.09.2023.
//

import SwiftUI
import UIKit

final class SignCoordinator {
    // dependency injection
    let container: DIContainer
    // storing all child coordinators
    var childCoordinators: [Coordinator] = []
    // navigationController is for navigation in UIKit
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController, container: DIContainer) {
        self.container = container
        self.navigationController = navigationController
        
        start()
    }
}

extension SignCoordinator: Coordinator {
    func start() {
        // first scene opened
        let signInViewController = makeSignIn()
        // set scene to navigation controller
        navigationController.setViewControllers([signInViewController], animated: true)
    }
}

// MARK: Factories
private extension SignCoordinator {
    func makeSignIn() -> UIViewController {
        // creating view
        let view = SignInView(store: SignInStore(validationManager: ValidationManager()), coordinator: self)
        // wrapping SwiftUI view for UIKit navigation
        return UIHostingController(rootView: view)
    }
    
    func makeSignOut() -> UIViewController {
        // creating view
        let view = SignOutView(store: SignOutStore(validationManager: ValidationManager(), apiManager: APIManager()))
        // wrapping SwiftUI view for UIKit navigation
        return UIHostingController(rootView: view)
    }
}

// MARK: Navigation
extension SignCoordinator: SignInEventHandling {
    func handle(event: SignInView.Event) {
        // coordinator handling navigation Events from SignInView
        switch event {
        case .goToSignOut:
            /*
             when user taps in SignInView to action `goToSignOut`
             we make SignOutView and use navigationController
             to push it -> navigate to that screen
             */
            let viewController = makeSignOut()
            navigationController.pushViewController(
                viewController,
                animated: true
            )
        }
    }
}
