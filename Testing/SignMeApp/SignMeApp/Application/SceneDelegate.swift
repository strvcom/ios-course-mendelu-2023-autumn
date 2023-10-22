//
//  SceneDelegate.swift
//  SignMeApp
//
//  Created by Martin Vidovic on 19.09.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator!
    var container: DIContainer!

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        let container = DIContainer()

        let appWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
        appWindow.windowScene = windowScene
        appCoordinator = AppCoordinator(window: appWindow, container: container)
    }
}
