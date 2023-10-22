//
//  Coordinator.swift
//  SignMeApp
//
//  Created by Martin Vidovic on 19.09.2023.
//

protocol Coordinator: AnyObject {
    var container: DIContainer { get }
    var childCoordinators: [Coordinator] { get set }

    func start()
}
