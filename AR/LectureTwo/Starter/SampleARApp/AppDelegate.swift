//
//  AppDelegate.swift
//  SampleARApp
//
//  Created by Tony Ngo on 30.08.2022.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: ExamplesViewController())
        window?.makeKeyAndVisible()

        return true
    }
}
