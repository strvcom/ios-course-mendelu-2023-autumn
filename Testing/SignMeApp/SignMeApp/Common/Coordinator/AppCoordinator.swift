//
//  AppCoordinator.swift
//  SignMeApp
//
//  Created by Martin Vidovic on 19.09.2023.
//

import UIKit

final class AppCoordinator {
    let container: DIContainer
    var childCoordinators = [Coordinator]()
    var rootCoordinator: Coordinator?
    let window: UIWindow

    init(window: UIWindow, container: DIContainer) {
        self.window = window
        self.container = container

        start(container: container)
    }
}

extension AppCoordinator {
    func start(container: DIContainer) {
        let navigationController = UINavigationController()
        let coordinator = SignCoordinator(navigationController: navigationController, container: container)
        childCoordinators.append(coordinator)
        rootCoordinator = coordinator
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
