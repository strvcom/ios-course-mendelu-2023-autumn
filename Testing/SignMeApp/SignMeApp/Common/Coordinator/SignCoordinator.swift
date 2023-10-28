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
        // dependency injection used here
        let store = container.signInStore
        // creating view
        let view = SignInView(store: store, coordinator: self)
        // wrapping SwiftUI view for UIKit navigation
        return UIHostingController(rootView: view)
    }
    
    func makeSignOut() -> UIViewController {
        // dependency injection used here
        let signOutStore = container.signOutStore
        // creating view
        let view = SignOutView(store: signOutStore, coordinator: self)
        // wrapping SwiftUI view for UIKit navigation
        return UIHostingController(rootView: view)
    }
}

// MARK: Navigation
extension SignCoordinator: SignInEventHandling, SignOutEventHandling {
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

    func handle(event: SignOutView.Event) {
        switch event {
        case .signOut:
            navigationController.popViewController(animated: true)
        }
    }
}

